{
  config,
  lib,
  pkgs,
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

  networking.hostName = lib.mkDefault "company";

  # While it would be simplier to just use networking.interfaces.<name>.ipv4.routes
  # to define custom routes, but GNOME desktop requires NetworkManager to be enabled, so we can
  # only use this method. After activate this flake, user should manually switch the profile on the
  # top-right in GNOME desktop.
  networking.networkmanager = {
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
          dns = "192.168.30.254";
        };
        ipv6.method = "ignore";
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 22 3389 7890 ];

  nix.use-china-mirrors = true;

  programs.clash-verge = {
    enable = true;
    autoStart = true;
    serviceMode = true;
    tunMode = true;
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

  # https://nixos.wiki/wiki/Remote_Desktop
  # Enable the GNOME RDP components
  services.gnome.gnome-remote-desktop.enable = true;

  # Ensure the service starts automatically at boot so the settings panel appears
  systemd.services.gnome-remote-desktop = {
    wantedBy = [ "graphical.target" ];
  };

  # Open the default RDP port (3389)
  # networking.firewall.allowedTCPPorts = [ 3389 ];

  # Disable autologin to avoid session conflicts
  services.displayManager.autoLogin.enable = false;
  services.getty.autologinUser = null;

  # Enable VSCode remote server support
  services.vscode-server.enable = true;
  programs.nix-ld.enable = true;
}
