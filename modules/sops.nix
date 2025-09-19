{ config, pkgs, ... }:

{
  sops.secrets = {
    samba_credencials = {
      file = "/etc/samba_credencials";
    };
  };
}
