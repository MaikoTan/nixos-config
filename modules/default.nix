{ config, pkgs, libs, ... }:

{
  imports = [
    ./common.nix
    ./nix.nix
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  users.mutableUsers = false;
  users.users.maiko = {
    isNormalUser = true;
    extraGroups = [ "wheel" ] ++ (if config.virtualisation.virtualbox.guest.enable then ["vboxsf"] else []);
    hashedPassword = "$y$j9T$k81nRyY0poxbHmfDBwwCa0$XNHfeUWV1mnR3kqr7md2pVAenx/6yBOqPknp2vMxZ16";
  };
}
