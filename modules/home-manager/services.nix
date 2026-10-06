# Background services: gpg-agent + remmina (remote desktop client, desktop only).
{
  config,
  lib,
  ...
}:

{
  services = lib.mkIf config.maiko.hm.services {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 4 * 60 * 60; # 4 hours
      maxCacheTtl = 8 * 60 * 60; # 8 hours
      defaultCacheTtlSsh = 4 * 60 * 60; # 4 hours
      maxCacheTtlSsh = 8 * 60 * 60; # 8 hours
      enableSshSupport = true;
    };

    # remote desktop client (desktop only)
    remmina = lib.mkIf config.maiko.hm.desktop {
      enable = true;
    };
  };
}
