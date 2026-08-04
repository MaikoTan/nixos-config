{ config, lib, ... }:

let
  cfg = config.maiko.libinput;
in

{
  options.maiko.libinput.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable libinput touchpad support";
  };

  config = lib.mkIf cfg.enable {
    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;
  };
}