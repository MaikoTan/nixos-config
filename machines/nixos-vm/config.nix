{ config, lib, pkgs, ... }:

{
  imports =
    [
      ../base/vbox-vm.nix
      ./hardware.nix
    ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  networking.hostName = "nixos-vm";
}
