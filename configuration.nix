# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";
  users.users.${config.wsl.defaultUser}.hashedPassword = "$y$j9T$uW.4l5bEUVn/ti07zAo.F.$41YQzEWa7WO05WjSzC/S1XVHKbeDTjNiQ2d4lF6ecX4";

  nix.extraOptions = ''
    experimental-features = nix-command flakes ca-derivations
  '';

  nix.settings = {
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
      "https://maiko-nixos-build.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "maiko-nixos-build.cachix.org-1:4EC5TVcsNL76xt7aqVoBpK0PoXPXuOF/kTLyjFyb8SM="
    ];

    trusted-users = [
      config.wsl.defaultUser
      "root"
    ];
  };

  programs.nix-ld.enable = true;
  programs.git.enable = true;
  programs.fish.enable = true;
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    nil
    curl
    wget
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
