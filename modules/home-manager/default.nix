{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # External
    inputs.android-nixpkgs.hmModule
    inputs.plasma-manager.homeModules.plasma-manager
    # Local feature modules
    ./agents/default.nix
    ./vscode/default.nix
    ./fish/default.nix
    ./desktop.nix
    ./ime.nix
    ./shells.nix
    ./machine.nix
    # New split modules
    ./android.nix
    ./git.nix
    ./extras.nix
    ./services.nix
    ./packages.nix
  ];

  home = {
    username = "maiko";
    homeDirectory = "/home/maiko";
    stateVersion = "25.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # X session (desktop only)
  xsession.enable = lib.mkIf config.maiko.hm.desktop true;
}
