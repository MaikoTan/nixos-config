{ config, lib, ... }:

let
  cfg = config.maiko.desktop-programs;
in

{
  options.maiko.desktop-programs.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable desktop-specific programs (KDE Connect, Chromium)";
  };

  config = lib.mkIf cfg.enable {
    # KDE Connect integration
    programs = {
      kdeconnect = {
        enable = true;
        # package = pkgs.gnomeExtensions.gsconnect;
      };

      chromium = {
        enable = true;
        enablePlasmaBrowserIntegration = true;
      };
    };
  };
}