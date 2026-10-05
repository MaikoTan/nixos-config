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
  };

  networking.networkmanager.enable = true;

  # Desktop-only program support (X11 apps under Wayland sessions and the
  # dconf store used by GTK applications).
  programs.xwayland.enable = true;
  programs.dconf.enable = true;

  # 常用开发服务器端口（Vite / Next.js / 通用 dev server），对所有桌面机器开放
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 5173;
      to = 5183;
    } # Vite dev server
    {
      from = 4000;
      to = 4010;
    } # Other common dev server ports
    {
      from = 3000;
      to = 3010;
    } # Next.js dev server
    {
      from = 8080;
      to = 8090;
    } # Common dev server port
  ];

  # Desktop environment use GRUB as the boot loader.
  boot.loader.grub = {
    enable = lib.mkDefault true;
    efiSupport = lib.mkDefault true;
    device = lib.mkDefault "nodev";
  };
}
