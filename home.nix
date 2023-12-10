{ config, pkgs, ... }:

{
  home.username = "maiko";
  home.homeDirectory = "/home/maiko";

  home.stateVersion = "23.11";

  home.packages = [
    pkgs.htop
    pkgs.fortune
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xsession.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
