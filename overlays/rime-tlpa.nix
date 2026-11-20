# 注入 rime-flypy（其依赖 rime-prelude，来自打了补丁的 nixpkgs）。
{ rime-patched-pkgs }:
_final: _prev: {
  inherit (rime-patched-pkgs) rime-flypy;
  rime-tlpa = _final.callPackage ../packages/rime-tlpa { };
}
