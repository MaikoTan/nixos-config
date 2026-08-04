{ config, lib, ... }:

{
  imports = [
    ./base.nix
  ];

  boot.kernelModules = [ "virtio_rng" ];

  networking.networkmanager.enable = true;

  virtualisation.virtualbox.guest = lib.mkIf config.virtualisation.virtualbox.guest.enable {
    clipboard = true;
    seamless = true;
    dragAndDrop = true;
  };
}
