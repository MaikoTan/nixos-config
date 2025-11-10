{ lib, ... }:

{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      ipv6 = true;
    };
  };

  users.users.maiko.extraGroups = lib.mkAfter [ "docker" ];
}
