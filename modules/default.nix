{ config, pkgs, libs, ... }:

{
  imports = [
    ./common.nix
    ./docker.nix
    ./ime.nix
    ./nix.nix
  ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.fish = {
    enable = true;
  };

  users.defaultUserShell = pkgs.fish;
  users.mutableUsers = false;
  users.users.maiko = {
    isNormalUser = true;
    extraGroups = [ "wheel" ] ++ (if config.virtualisation.virtualbox.guest.enable then ["vboxsf"] else []);
    hashedPassword = "$y$j9T$k81nRyY0poxbHmfDBwwCa0$XNHfeUWV1mnR3kqr7md2pVAenx/6yBOqPknp2vMxZ16";
  };
}
