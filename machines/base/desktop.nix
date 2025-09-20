{ lib, ... }:

{
  imports = [ ./config.nix ];

  # Desktop environment use GRUB as the boot loader.
  boot.loader.grub = {
    enable = lib.mkDefault true;
    efiSupport = lib.mkDefault true;
    device = lib.mkDefault "nodev";
  };

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  console = {
    font = lib.mkDefault "Lat2-Terminus16";
    useXkbConfig = lib.mkDefault true; # use xkb.options in tty.
  };
}
