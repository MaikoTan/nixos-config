# 本地 overlay 汇总入口：顺序与 flake.nix 中原先的内联顺序一致，不可随意重排。
{ rime-patched-pkgs }:
[
  (import ./rime-tlpa.nix { inherit rime-patched-pkgs; })
  (import ./freedownloadmanager.nix)
  (import ./magpie.nix)
  (import ./miku-cursors.nix)
  (import ./github-copilot-app.nix)
  (import ./dsh.nix)
  (import ./node-addon-require-builtin.nix)
  (import ./node-addon-api.nix)
]
