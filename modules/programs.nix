{ config, lib, ... }:

let
  cfg = config.maiko.programs;
in

{
  options.maiko.programs.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable common programs";
  };

  config = lib.mkIf cfg.enable {
    # KDE Connect integration
    programs = {
      kdeconnect = {
        enable = true;
        # package = pkgs.gnomeExtensions.gsconnect;
      };

      xwayland.enable = true;

      dconf.enable = true;

      fish.enable = true;

      git.enable = true;

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      chromium = {
        enable = true;
        enablePlasmaBrowserIntegration = true;
      };
    };
  };
}