{
  config,
  lib,
  pkgs,
  ...
}:

{
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
  };

  programs.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        governor = "performance";
        turbo = "always";
      };
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

  sops.secrets.zerotierNetworks = {
    sopsFile = ../../secrets/network_bridges.yaml;
    key = "zerotier/networks";
  };

  users.users.maiko.extraGroups = [
    "samba"
    "adbusers"
  ];
}
