{ config, lib, ... }:

{
  imports = [
    ./base.nix
  ];

  boot.kernelModules = [ "virtio_rng" ];

  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  virtualisation.virtualbox.guest = lib.mkIf config.virtualisation.virtualbox.guest.enable {
    clipboard = true;
    seamless = true;
    dragAndDrop = true;
  };
}
