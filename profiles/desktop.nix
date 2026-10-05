{ lib, ... }:

{
  imports = [
    ./base.nix
    ../modules/nixos/fonts/default.nix
    ../modules/nixos/display-manager/default.nix
    ../modules/nixos/desktop.nix
    ../modules/nixos/pipewire/default.nix
    ../modules/nixos/libinput/default.nix
    ../modules/nixos/printing/default.nix
    ../modules/nixos/docker/default.nix
    ../modules/nixos/ime/default.nix
    ../modules/nixos/miku-cursors/default.nix
    ../modules/nixos/remote-desktop.nix
    ../modules/nixos/networking/dev-ports.nix
    ../modules/nixos/boot/grub.nix
  ];

  maiko = {
    fonts.enable = true;
    display-manager.enable = true;
    desktop-programs.enable = true;
    pipewire.enable = true;
    libinput.enable = true;
    printing.enable = true;
    docker.enable = true;
    ime.enable = true;
    miku-cursors.enable = true;
    remote-desktop.enable = true;
    dev-ports.enable = true;
  };

  networking.networkmanager.enable = true;

  # Desktop-only program support (X11 apps under Wayland sessions and the
  # dconf store used by GTK applications).
  programs.xwayland.enable = true;
  programs.dconf.enable = true;
}
