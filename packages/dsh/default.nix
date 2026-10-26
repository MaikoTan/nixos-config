{
  lib,
  buildNpmPackage,
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
  nodejs_22,
  node-addon-require-builtin,
}:

let
  # 由 nvfetcher 生成（见 ../nvfetcher.toml），升级时重新运行 nvfetcher 即可更新 hash。
  sources = import ../_sources/generated.nix {
    inherit
      fetchgit
      fetchurl
      fetchFromGitHub
      dockerTools
      ;
  };

  # 使用 Node.js 22。注意：web profile 需要的原生模块 node-addon-require-builtin
  # 在 Node.js 22/24 上的运行时探测存在兼容性问题 (upstream bug)。
  # headless/tui profile 可正常工作。
  nodejsToUse = nodejs_22;
in

buildNpmPackage {
  pname = "dsh";
  version = sources.dsh.version;

  src = sources.dsh.src;

  # 指定 Node.js 24，避免原生模块 NAPI 版本不匹配 (node-addon-require-builtin 要求 napi-v9 / Node 24)。
  nodejs = nodejsToUse;

  # npm tarball 只带 package.json，没有 lockfile。闭包含 86 个直接依赖、
  # 60+ 个同版本的 @deepseek-ai/dsh-* 子包，必须用同一 registry 解析出的
  # lockfile 才能复刻；否则 npm 现场联网解析，结果不可复现。
  # 生成方式：解包 src，在其目录里
  #   npm install --package-lock-only --ignore-scripts --no-audit --no-fund
  # 上游版本变化后需重新生成。
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  # 上游是预打包 CJS，没有 build 步骤，装完依赖即可用。
  dontNpmBuild = true;

  # 5 个包带 install 脚本（protobufjs / koffi / node-pty / @google/genai /
  # @deepseek-ai/dsh-subprocess-local），其中原生模块必须编译才能运行。
  # 我们跳过所有 install 脚本，稍后手动替换 node-addon-require-builtin。
  npmFlags = [ "--ignore-scripts" ];

  npmDepsHash = "sha256-3sTALSlZn3RYnRT75LRg3q+iBYvuzyQl3EjCa76CN48=";

  # 替换 node-addon-require-builtin 为我们的自定义构建版本
  # 先运行默认 installPhase (复制 node_modules)，再替换特定模块
  installPhase = ''
    # Default installPhase from buildNpmPackage copies node_modules to $out
    mkdir -p $out/lib
    cp -r node_modules $out/lib/
    cp package.json $out/lib/
    cp -r lib $out/lib/ 2>/dev/null || true
    # Replace node-addon-require-builtin with our custom build
    rm -rf $out/lib/node_modules/node-addon-require-builtin
    cp -r ${node-addon-require-builtin}/lib/node_modules/node-addon-require-builtin $out/lib/node_modules/
    # Also copy the native module to $out/lib/ where the entry point expects it
    cp ${node-addon-require-builtin}/lib/require_builtin.node $out/lib/
    # Create bin wrapper for dsh
    mkdir -p $out/bin
    printf '#!/usr/bin/env bash\n# Use the Node.js from the package\nexec %s/bin/node %s/lib/lib/bin.js "$@"\n' "${nodejsToUse}" "$out" > $out/bin/dsh
    chmod +x $out/bin/dsh
  '';

  meta = {
    description = "DeepSeek Agent CLI / harness";
    homepage = "https://www.deepseek.com";
    license = lib.licenses.unfree;
    mainProgram = "dsh";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ maikotan ];
  };
}
