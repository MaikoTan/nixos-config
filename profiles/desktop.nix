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
