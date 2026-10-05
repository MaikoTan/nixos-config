# 注入 rime-flypy，并从打了补丁的 nixpkgs 提供 rime-prelude。
{ rime-patched-pkgs }:
_final: _prev: {
  inherit (rime-patched-pkgs) rime-flypy;
  rime-tlpa = _final.callPackage ../packages/rime-tlpa {
    inherit (rime-patched-pkgs) rime-prelude;
  };
}
