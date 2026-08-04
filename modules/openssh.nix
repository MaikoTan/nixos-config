{ config, lib, ... }:

let
  cfg = config.maiko.openssh;
in

{
  options.maiko.openssh.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the OpenSSH daemon";
  };

  config = lib.mkIf cfg.enable {
    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
  };
}