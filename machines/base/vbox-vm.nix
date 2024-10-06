{ ... }:

{
  imports = [ ./config.nix ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  virtualisation.virtualbox.guest = {
    enable = true;
    clipboard = true;
    seamless = true;
    dragAndDrop = true;
  };
}
