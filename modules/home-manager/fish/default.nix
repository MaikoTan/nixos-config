{
  config,
  lib,
  pkgs,
  ...
}:

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
