# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ../../profiles/wsl-base.nix
    inputs.vscode-server.nixosModules.default
  ];

  wsl.defaultUser = "nixos";
  users.users.${config.wsl.defaultUser}.hashedPassword =
    "$y$j9T$uW.4l5bEUVn/ti07zAo.F.$41YQzEWa7WO05WjSzC/S1XVHKbeDTjNiQ2d4lF6ecX4";

  maiko.nix.useChinaMirrors = true;

  nix.settings.trusted-users = lib.mkAfter [
    config.wsl.defaultUser
  ];

  programs = {
    git.enable = true;
    fish.enable = true;
  };
  services.openssh = {
    enable = true;
    ports = [ 2223 ];
  };

  networking.firewall.allowedTCPPorts = [ 2223 ];

  environment.systemPackages = with pkgs; [
    nil
    curl
    wget
  ];
}
