{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./common.nix
    ./docker.nix
    ./ime.nix
    ./nix.nix
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  users.mutableUsers = false;
  users.users.maiko = {
    isNormalUser = true;
    extraGroups = lib.mkMerge [
      [ "wheel" ]
      (lib.mkIf config.virtualisation.virtualbox.guest.enable [ "vboxsf" ])
    ];
    # mkpasswd -m sha-512
    hashedPassword = "$6$ghV5XrAdy1cLYxTi$CQKgb.ywKGlhsUBzV4WSCG9aioZOl0Q2NgV8f7f7akLizzKgRNSIXk7PIIO.zoJXKEH4fcLWusWIg6A7XX1Jv/";
  };
}
