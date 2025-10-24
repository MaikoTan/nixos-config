{
  config,
  lib,
  nixos-hardware,
  ...
}:

{
  imports = [
    # Import common configuration from nixos
    nixos-hardware.nixosModules.common-cpu-intel
    ../base/desktop.nix
    ./hardware.nix
  ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  networking = lib.mkDefault {
    hostName = "company";
    networkmanager = {
      enable = true;
      dns = "none";
    };
    useDHCP = false;
    dhcpcd.enable = false;
    interfaces.enp2s0 = {
      ipv4.addresses = [
        {
          address = "192.168.30.80";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.30.254";
      interface = "enp2s0";
    };
    nameservers = ["192.168.30.254"];
  };

  nix.use-china-mirrors = true;

  programs.clash-verge = {
    enable = true;
    autoStart = true;
  };

  # Automatically join the ZeroTier network.
  services.zerotierone = {
    enable = true;
  };

  sops.secrets.zerotierNetworks = {
    sopsFile = ../../secrets/network_bridges.yaml;
    key = "zerotier/networks";
  };
  systemd.services.zerotierone = {
    preStart = lib.mkAfter ''
      if [ -f "${config.sops.secrets.zerotierNetworks.path}" ]; then
        for netid in $(cat "${config.sops.secrets.zerotierNetworks.path}"); do
          touch "/var/lib/zerotier-one/networks.d/$netid.conf"
        done
      fi
    '';
  };

  # Enable Tailscale
  # Note that Tailscale has no configuration here; it is all managed via the Tailscale admin console.
  services.tailscale = {
    enable = true;
  };
}
