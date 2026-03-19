{ lib, osConfig, ... }:

{
  imports = lib.optionals osConfig.services.desktopManager.plasma6.enable [
    ./plasma-rc.nix
  ];
}
