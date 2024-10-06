{ config, lib, pkgs, ... }:

{
  imports =
    [
      ../base/vbox-vm.nix
      ./hardware.nix
    ];

  networking.hostName = "work-vm";
}
