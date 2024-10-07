# This file is acted as a nix module for configuring a VirtualBox VM.
# In VM configs, you could enable VirtualBox guest additions and other VM-specific settings
# by importing this file. For example, in machines/nixos-vm/config.nix:
#
# ```nix
# {
#   imports = [ ../base/vbox-vm.nix ];
# }
# ```

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
