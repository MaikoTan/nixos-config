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

  # miku-cursors 的 attr 名带连字符，需用 builtins.getAttr 访问。
  # 用 let 绑定后再 inherit，符合 statix 风格（避免 "Assignment instead of inherit" 警告）。
  mikuCursorsSrc = builtins.getAttr "miku-cursors" sources;
in

stdenvNoCC.mkDerivation {
  pname = "miku-cursors";
  inherit (mikuCursorsSrc) version src;

  # 源码 tarball 解包后顶层目录为 hatsune-miku-windows-linux-cursors-<ver>，
  # stdenv 自动 sourceRoot 检测会进入该目录，PWD 即为解包后的源码根。
  buildPhase = ''
    set -euo pipefail
    mkdir -p $out/share/icons/miku-cursor
    cp -r miku-cursor-linux/* $out/share/icons/miku-cursor/
  '';
}
