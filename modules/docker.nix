{ config, lib, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    rootless.enable = true;
    daemon.settings = {
      ipv6 = true;
    };
  };
}
