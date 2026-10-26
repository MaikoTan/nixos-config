{ lib, stdenv, fetchFromGitHub, nodejs, node-addon-api, python3, node-gyp }:

stdenv.mkDerivation {
  pname = "node-addon-require-builtin";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "deepseek-ai";
    repo = "dsh-node-addon-require-builtin";
    rev = "c4a7757bfcdacc71597447fd3eb30fae702ef19e";
    hash = "sha256-IUzf4e/kuiXmg40eAlIQ1zf9XGUrw4XGjYkjzl6p5M0=";
  };

  # Apply XOR patch for Node.js 22+ builtin_module_require (xor edi, edi)
  # Patch file is at ./xor-patch.patch relative to this file
  patches = [ ./xor-patch.patch ];

  nativeBuildInputs = [ nodejs node-addon-api python3 node-gyp ];

  # Don't use cmake, use node-gyp instead
  cmakeFlags = [];

  # Build the native module from packages/native with NAPI backend
  buildPhase = ''
    # The source is already unpacked and patched in the current directory
    # Copy to /tmp for writable build space (nix sandbox: build dir may have restrictions)
    cp -r packages/native /tmp/
    cd /tmp/native
    # Fix permissions (source may be read-only)
    chmod -R u+w .
    # DEBUG: Check if patch was applied
    echo "=== Checking patched getter_decoder.cc ==="
    grep -n "kXorRegReg" src/runtime_probe/getter_decoder.cc || echo "PATCH NOT FOUND!"

    # Manually apply remaining patches that didn't apply via patchPhase
    # The patch file only applied the first hunk (enum), need to add:
    # 1. XOR decoding in DecodeX64 after kRet handling
    # 2. kXorRegReg to WalkX64Getter switch
    # Copy and run Python patch script
    cp ${./apply_xor_patch.py} /tmp/apply_xor_patch.py
    python3 /tmp/apply_xor_patch.py

    # DEBUG: Check final patched file
    echo "=== Final patched getter_decoder.cc ==="
    grep -n "kXorRegReg" src/runtime_probe/getter_decoder.cc || echo "PATCH NOT FOUND!"

    # Make node-addon-api available to node-gyp (it does require('node-addon-api'))
    # Copy headers and .gyp files, create proper package structure
    mkdir -p node_modules/node-addon-api
    cp -r ${node-addon-api}/include/* node_modules/node-addon-api/
    chmod -R u+w node_modules
    # Create package.json
    echo '{"name":"node-addon-api","version":"8.9.2","main":"index.js","license":"MIT"}' > node_modules/node-addon-api/package.json
    # Create index.js that mimics the real node-addon-api exports
    cat > node_modules/node-addon-api/index.js << 'EOJS'
const path = require('path');
const { version } = require('./package.json');
const includeDir = path.relative('.', __dirname);
module.exports = {
  include: `__dirname`,
  include_dir: includeDir,
  gyp: path.join(includeDir, 'node_api.gyp:nothing'),
  targets: path.join(includeDir, 'node_addon_api.gyp'),
  version,
  isNodeApiBuiltin: true,
  needsFlag: false
};
EOJS
    # Ensure build directory exists and is writable (node-gyp creates build/ in cwd)
    mkdir -p build
    # Use node-gyp with napi backend, NAPI v9 for Node.js 22
    # Patch binding.gyp to ensure C++17 is used and product is require-builtin
    # Use awk to handle multi-line cflags_cc array
    awk '/"cflags_cc": \[/ {print; print "        \"-std=c++17\","; next} 1' binding.gyp > binding.gyp.new && mv binding.gyp.new binding.gyp
    # Change default product from internal-loader to require-builtin
    echo "=== Before sed: ==="
    grep "narb_product" binding.gyp
    sed -i 's/"narb_product%": "internal-loader"/"narb_product%": "require-builtin"/' binding.gyp
    echo "=== After sed: ==="
    grep "narb_product" binding.gyp
    # Use NAPI_VERSION=9 for Node.js 22 (already set in binding.gyp)
    ${node-gyp}/bin/node-gyp configure \
      --backend=napi \
      --target=${nodejs.version} \
      --napi_version=9
    ${node-gyp}/bin/node-gyp build
  '';

  installPhase = ''
    mkdir -p $out/lib
    # The native module is built as require_builtin.node in /tmp/native/build/Release
    cp /tmp/native/build/Release/require_builtin.node $out/lib/
    # Also create a package.json for npm to recognize it
    mkdir -p $out/lib/node_modules/node-addon-require-builtin
    cat > $out/lib/node_modules/node-addon-require-builtin/package.json << 'EOJSON'
{
  "name": "node-addon-require-builtin",
  "version": "0.1.9",
  "main": "lib/index.js",
  "license": "MIT"
}
EOJSON
    # Create a simple entry point that loads the native module directly
    mkdir -p $out/lib/node_modules/node-addon-require-builtin/lib
    cat > $out/lib/node_modules/node-addon-require-builtin/lib/index.js << 'EOJS'
const path = require('path');
// Load the native module from the package's lib directory (alongside this file)
const nativePath = path.resolve(__dirname, '..', '..', '..', '..', 'lib', 'require_builtin.node');
const native = require(nativePath);

function getBindingInfo() {
  const nativeInfo = native.getNativeBindingInfo();
  return Object.freeze({
    mode: nativeInfo.mode,
    product: nativeInfo.product,
    backend: nativeInfo.backend,
    abi: nativeInfo.abi,
    bindingPath: nativePath,
    bindingSource: 'nix-build',
    localBindingPath: nativePath,
    optionalPackageName: 'node-addon-require-builtin-' + nativeInfo.abi.toLowerCase().replace('napi-v', 'napi-'),
    optionalBinaryRelativePath: 'prebuilt/require_builtin.node',
    platformPackageSuffix: process.platform + '-' + process.arch,
  });
}

module.exports = {
  requireBuiltin: native.requireBuiltin,
  isAllowedInternalId: native.isAllowedInternalId,
  getBindingInfo,
  // Also export the native functions directly for compatibility
  getNativeBindingInfo: native.getNativeBindingInfo,
};
EOJS
  '';
}
