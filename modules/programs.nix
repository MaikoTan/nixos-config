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
    programs = {
      xwayland.enable = true;

      dconf.enable = true;

      fish.enable = true;

      git.enable = true;

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
  };
}