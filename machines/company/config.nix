{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Import common configuration from nixos
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.vscode-server.nixosModules.default
    inputs.auto-cpufreq.nixosModules.default

    ./hardware.nix
    ../../profiles/desktop.nix
  ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  services = {
    power-profiles-daemon.enable = false;
    scx = {
      enable = true;
      scheduler = "scx_lavd";
    };
    zerotierone = {
      enable = true;
    };
    tailscale = {
      enable = true;
    };
    # https://nixos.wiki/wiki/Remote_Desktop
    # Enable the GNOME RDP components
    gnome.gnome-remote-desktop.enable = true;
    displayManager.autoLogin.enable = false;
    getty.autologinUser = null;
    samba = {
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
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };
    vscode-server.enable = true;
    github-runners = {
      maintenir = {
        enable = true;
        name = "company-nixos";
        tokenFile = config.sops.secrets.maintenirGitHubRunnerToken.path;
        url = "https://github.com/maintenir";
        nodeRuntimes = [ "node24" ];
      };
      nixos-config = {
        enable = true;
        name = "company-nixos";
        extraLabels = [ "nixos" ];
        user = "github-runner";
        group = "github-runner";
        extraPackages = with pkgs; [ nix ];
        tokenFile = config.sops.secrets.nixosGithubToken.path;
        url = "https://github.com/MaikoTan/nixos-config";
        nodeRuntimes = [ "node24" ];
      };
    };
  };

  programs = {
    auto-cpufreq = {
      enable = true;
      settings = {
        charger = {
          governor = "performance";
          turbo = "always";
        };
      };
    };
    clash-verge = {
      enable = true;
      autoStart = true;
      serviceMode = true;
      tunMode = true;
    };
  };

  # TODO: Fix GTK4 apps rendering issue with Intel UHD 630
  environment.sessionVariables = {
    GSK_RENDERER = "gl";
  };

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

  maiko.nix.useChinaMirrors = true;

  sops.secrets = {
    companyGitHubToken = {
      sopsFile = ../../secrets/github_tokens.yaml;
      key = "company";
      owner = "maiko";
    };
    maintenirGitHubRunnerToken = {
      sopsFile = ../../secrets/github_tokens.yaml;
      key = "maintenir_github_runner";
    };
    nixosGithubToken = {
      sopsFile = ../../secrets/github_tokens.yaml;
      key = "nixos_github_runner";
    };
    zerotierNetworks = {
      sopsFile = ../../secrets/network_bridges.yaml;
      key = "zerotier/networks";
    };
  };

  # ZeroTier's default MTU is 2800, which causes issues on Windows side. Set it to 1280 to be safe.
  # This systemd.network config name is taken from nixpkgs, see
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/zerotierone.nix
  systemd = {
    network.links."50-zerotier".linkConfig.MTUBytes = 1280;

    services = {
      zerotierone = {
        preStart = lib.mkAfter ''
          if [ -f "${config.sops.secrets.zerotierNetworks.path}" ]; then
            for netid in $(cat "${config.sops.secrets.zerotierNetworks.path}"); do
              touch "/var/lib/zerotier-one/networks.d/$netid.conf"
            done
          fi
        '';
      };
      # Ensure the service starts automatically at boot so the settings panel appears
      gnome-remote-desktop = {
        wantedBy = [ "graphical.target" ];
      };
    };
  };

  users = {
    users = {
      maiko.extraGroups = [
        "samba"
        "adbusers"
      ];
      github-runner = {
        isSystemUser = true;
        group = "github-runner";
        extraGroups = [
          "networkmanager"
          "docker"
        ];
      };
    };
    groups.github-runner = { };
  };

  nix.settings.trusted-users = lib.mkAfter [ "github-runner" ];
}
