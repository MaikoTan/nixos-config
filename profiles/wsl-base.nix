{ config, lib, inputs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    inputs.nixos-wsl.nixosModules.default
    ./base.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = lib.mkDefault "nixos";
}
