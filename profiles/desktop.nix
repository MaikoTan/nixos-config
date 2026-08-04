{ lib, ... }:

{
  imports = [
    ./base.nix
    ../modules/display-manager.nix
    ../modules/desktop-programs.nix
    ../modules/pipewire.nix
    ../modules/libinput.nix
    ../modules/printing.nix
    ../modules/docker.nix
    ../modules/ime.nix
    ../modules/miku-cursors.nix
  ];

  maiko.display-manager.enable = true;
  maiko.desktop-programs.enable = true;
  maiko.pipewire.enable = true;
  maiko.libinput.enable = true;
  maiko.printing.enable = true;
  maiko.docker.enable = true;
  maiko.ime.enable = true;
  maiko.miku-cursors.enable = true;

  networking.networkmanager.enable = true;

  # Desktop environment use GRUB as the boot loader.
  boot.loader.grub = {
    enable = lib.mkDefault true;
    efiSupport = lib.mkDefault true;
    device = lib.mkDefault "nodev";
  };
}
