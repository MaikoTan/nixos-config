{ config, lib, ... }:

let
  cfg = config.maiko.printing;
in

{
  options.maiko.printing.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable CUPS printing";
  };

  config = lib.mkIf cfg.enable {
    # Enable CUPS to print documents.
    services.printing.enable = true;
  };
}