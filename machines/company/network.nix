{
  config,
  lib,
  ...
}:

{
  networking = {
    hostName = lib.mkDefault "company";

    # While it would be simplier to just use networking.interfaces.<name>.ipv4.routes
    # to define custom routes, but GNOME desktop requires NetworkManager to be enabled, so we can
    # only use this method. After activate this flake, user should manually switch the profile on the
    # top-right in GNOME desktop.
    networkmanager = {
      enable = true;

      ensureProfiles.profiles = {
        company-network = {
          connection = {
            id = "company-ethernet";
            type = "ethernet";
            interface-name = "enp2s0";
          };
          ipv4 = {
            method = "manual";
            addresses = "192.168.30.80/24";
            gateway = "192.168.30.254";
            routes = "192.168.100.0/24,192.168.30.254";
            dns = "192.168.100.10";
          };
          ipv6.method = "ignore";
        };
      };
    };
    firewall.allowedTCPPorts = [
      22
      3389
      7890
    ];
    proxy =
      let
        cfg = config.programs.clash-verge;
        endpoint = "http://127.0.0.1:7890";
      in
      lib.mkIf (cfg.enable && cfg.autoStart) {
        httpProxy = endpoint;
        httpsProxy = endpoint;
        noProxy = "localhost,127.0.0.0/8,::1";
      };
  };

  programs.clash-verge = {
    enable = true;
    autoStart = true;
    serviceMode = true;
    tunMode = true;
  };

  maiko.nix.useChinaMirrors = true;
}
