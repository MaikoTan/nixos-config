{
  lib,
  stdenvNoCC,
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
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
in

stdenvNoCC.mkDerivation {
  pname = "miku-cursors";
  version = (builtins.getAttr "miku-cursors" sources).version;

  src = (builtins.getAttr "miku-cursors" sources).src;

  # 源码 tarball 解包后顶层目录为 hatsune-miku-windows-linux-cursors-<ver>，
  # stdenv 自动 sourceRoot 检测会进入该目录，PWD 即为解包后的源码根。
  buildPhase = ''
    set -euo pipefail
    mkdir -p $out/share/icons/miku-cursor
    cp -r miku-cursor-linux/* $out/share/icons/miku-cursor/
  '';
}
