{ config, pkgs, ... }:

{
  imports =
    [
      ./vscode/default.nix
    ];

  home.username = "maiko";
  home.homeDirectory = "/home/maiko";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    htop
    rsync
    transmission_4
    libsForQt5.yakuake
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv.enable = true;

  xsession.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
