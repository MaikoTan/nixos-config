{ config, lib, ... }:

let
  cfg = config.maiko.pipewire;
in

{
  options.maiko.pipewire.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable PipeWire sound";
  };

  config = lib.mkIf cfg.enable {
    # Enable sound.
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };
}