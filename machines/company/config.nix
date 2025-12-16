{
  config,
  inputs,
  lib,
  ...
}:

{
  imports = [
    # Import common configuration from nixos
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.vscode-server.nixosModules.default
    inputs.home-manager.nixosModules.home-manager

    ../base/desktop.nix
    ./hardware.nix
    ../../modules/default.nix
  ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # TODO: Fix GTK4 apps rendering issue with Intel UHD 630
  environment.sessionVariables = {
    GSK_RENDERER = "gl";
  };

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
  networking.firewall.allowedTCPPorts = [
    22
    3389
    7890
  ];
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 5173;
      to = 5183;
    } # Vite dev server
    {
      from = 4000;
      to = 4010;
    } # Other common dev server ports
    {
      from = 3000;
      to = 3010;
    } # Next.js dev server
    {
      from = 8080;
      to = 8090;
    } # Common dev server port
  ];

  maiko.nix.useChinaMirrors = true;

  programs.clash-verge = {
    enable = true;
    autoStart = true;
    serviceMode = true;
    tunMode = true;
  };

  networking.proxy =
    let
      cfg = config.programs.clash-verge;
      endpoint = "http://127.0.0.1:7890";
    in
    lib.mkIf (cfg.enable && cfg.autoStart) {
      httpProxy = endpoint;
      httpsProxy = endpoint;
      noProxy = "localhost,127.0.0.0/8,::1";
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

  services.samba = {
    # package = pkgs.samba4Full; # Full featured samba with AD support break the Python bindings
    usershares.enable = true;
    enable = true;
    openFirewall = true;

    settings = {
      maikoHome = {
        path = "/home/maiko";
        comment = "Maiko's Home Folder";
        browseable = true;
        "read only" = false;
        "guest ok" = false;
        "valid users" = [ "maiko" ];
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };
  # To be discoverable with windows
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "enp2s0";
      WIFI_IFACE = "wlp3s0";
      SSID = "company";
      PASSPHRASE = "aa113115";
    };
  };

  # Enable VSCode remote server support
  services.vscode-server.enable = true;
  programs.nix-ld.enable = true;

  programs.adb.enable = true;
  users.users.maiko.extraGroups = [
    "samba"
    "adbusers"
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.maiko = import ../../modules/home-manager;
  };
}
