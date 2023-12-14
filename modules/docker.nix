{ config, lib, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    rootless.enable = true;
    rootless.daemon.settings = {
      ipv6 = true;
    };
  };
}
