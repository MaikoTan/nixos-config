# nixpkgs 实例，应用 nixpkgs PR #501829 补丁（rime-prelude 相关修复），
# 并放开 unfree 限制。仅供 rime-flypy / rime-tlpa 使用。
{ nixpkgs }:
let
  pkgs = import nixpkgs { system = "x86_64-linux"; };
in
import
  (pkgs.applyPatches {
    name = "rime-patched";
    src = nixpkgs;
    patches = [
      (pkgs.fetchpatch {
        url = "https://github.com/NixOS/nixpkgs/pull/501829.patch";
        hash = "sha256-Ng518PqrRBzek7JxaIjAY0GV00ldZY6DKeM+Go8RvF8=";
      })
    ];
  })
  {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  }
