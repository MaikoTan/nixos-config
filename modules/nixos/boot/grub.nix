{ lib, ... }:{  # Desktop environment use GRUB as the boot loader.  boot.loader.grub = {    enable = lib.mkDefault true;    efiSupport = lib.mkDefault true;    device = lib.mkDefault "nodev";  };}
