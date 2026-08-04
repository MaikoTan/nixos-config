{ config, lib, ... }:

let
  cfg = config.maiko.docker;
in

{
  options.maiko.docker.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Docker";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      daemon.settings = {
        ipv6 = true;
      };
    };

    users.users.maiko.extraGroups = lib.mkAfter [ "docker" ];
  };
}
