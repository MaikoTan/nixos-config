{
  config,
  lib,
  pkgs,
  ...
}:

let

  nodejs = pkgs.nodejs_22;
  yarn = pkgs.writeShellScriptBin "yarn" ''
    exec ${nodejs}/bin/corepack yarn@4 "$@"
  '';
  pnpm = pkgs.writeShellScriptBin "pnpm" ''
    exec ${nodejs}/bin/corepack pnpm@latest "$@"
  '';

in

{
  imports = [
    ./prompt.nix
    ./ssh-agent.nix
    ./yarn.nix
  ];

  programs.fish.enable = true;

  # Enable zoxide fish integration only if zoxide is enabled
  programs.zoxide.enableFishIntegration = lib.mkIf config.programs.zoxide.enable true;
}
