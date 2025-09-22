{ config, lib, pkgs, ... }:

{
  imports =
    [
      ../company/config.nix
      ../base/vbox-vm.nix
    ];

  networking.hostName = "nixos-vm";
}
