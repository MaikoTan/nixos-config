{
  lib,
  buildNpmPackage,
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
  nodejs ? null,
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

  # 使用 Node.js 24 以匹配原生模块 (node-addon-require-builtin) 的 NAPI v9 要求。
  # nodejs_24 在 nixpkgs 中为 24.21.0，与原生模块的 binary_abi: napi-v9 匹配。
  nodejsToUse = if nodejs != null then nodejs else (import <nixpkgs> { }).nodejs_24;
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
  npmFlags = [ "--ignore-scripts=false" ];

  npmDepsHash = "sha256-3sTALSlZn3RYnRT75LRg3q+iBYvuzyQl3EjCa76CN48=";

  meta = {
    description = "DeepSeek Agent CLI / harness";
    homepage = "https://www.deepseek.com";
    license = lib.licenses.unfree;
    mainProgram = "dsh";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ maikotan ];
  };
}
