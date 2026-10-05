# 修复 hermes-agent 中写死的 electron headers hash.
# electronHeaders 在 nix/desktop.nix 的 let 绑定中，override 无法触及，
# 因此用 applyPatches 打补丁源码后再 callPackage。
{ hermes-agent, super }:
let
  patchedHermesSrc =
    super.runCommandLocal "hermes-agent-patched"
      {
        nativeBuildInputs = [ super.gnused ];
      }
      ''

        cp -r "${hermes-agent}" "$out"
        chmod -R +w "$out"
        substituteInPlace "$out/nix/desktop.nix" \
          --replace-fail \
            "sha256-f8bSbLRmtbP93CJAvEBs+sHWDZ1xP2bcpLhC1EnOmZU=" \
            "sha256-xDgc5PpkcLpWHnlqVcjBD3SxJKtkUoSGLnJaSSrxJtI="
      '';
  hermesAgent = hermes-agent.packages.x86_64-linux.default;
in
super.callPackage "${patchedHermesSrc}/nix/desktop.nix" {
  inherit (super) electron;
  inherit hermesAgent;
  inherit (hermesAgent) hermesNpmLib;
}
