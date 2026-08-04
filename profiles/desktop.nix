{ lib, ... }:

{
  imports = [
    ./base.nix
    ../modules/display-manager.nix
    ../modules/pipewire.nix
    ../modules/libinput.nix
    ../modules/printing.nix
    ../modules/docker.nix
    ../modules/ime.nix
    ../modules/miku-cursors.nix
  ];

  maiko.display-manager.enable = true;
  maiko.pipewire.enable = true;
  maiko.libinput.enable = true;
  maiko.printing.enable = true;
  maiko.docker.enable = true;
  maiko.ime.enable = true;
  maiko.miku-cursors.enable = true;

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
