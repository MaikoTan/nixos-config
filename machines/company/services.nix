{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  # randamu 下载目录依赖 maiko 的 home 目录，从 users 配置取值，避免硬编码
  maikoHome = config.users.users.maiko.home;
in
{
  imports = [
    inputs.randamu.nixosModules.default
  ];

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
    # Remote desktop is provided by maiko.remote-desktop (KRDP) in
    # profiles/desktop.nix. Do not enable services.gnome.gnome-remote-desktop
    # here: GNOME's remote desktop competes with KRDP for port 3389, and the
    # GNOME implementation does not support a Wayland session.
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
    randamu = {
      enable = true;
      # 服务以 maiko 身份运行，直接下载到其 Pictures 目录
      user = "maiko";
      group = "users";
      createUser = false;
      imagesDir = "${maikoHome}/Pictures/pixiv";
      stateDir = "${maikoHome}/.local/state/randamu";
      refreshTokenFile = config.sops.secrets.pixivRefreshToken.path;
      settings = {
        sources = [
          {
            type = "bookmarks";
            restrict = "public";
            limit = 100;
          }
          {
            type = "bookmarks";
            restrict = "private";
            limit = 100;
          }
          {
            type = "recommended";
            limit = 100;
          }
        ];
        skip_ai = true;
        skip_r18 = false;
        skip_r18g = true;
        blacklist_tags = [
          "漫画"
          "講座"
          "描き方"
          "MMD"
          "3D"
          "3Dカスタム少女"
        ];
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

      # nix build processes all live in the /system.slice/nix-daemon.service
      # cgroup (daemon mode; "nix store ping" reports Store URL: daemon). Cap
      # that cgroup's memory: above MemoryHigh the kernel reclaims and throttles
      # instead of killing, above MemoryMax only that cgroup gets OOM-killed -- a
      # build dies instead of the whole user.slice freezing.
      nix-daemon.serviceConfig = {
        MemoryHigh = "6G";
        MemoryMax = "10G";
      };
    };

    # systemd-oomd never fired here: swap-based killing stays off because
    # ManagedOOMSwap remains "auto", and 80% memory pressure sustained for 30s
    # was never reached before the kernel's global OOM took over. When it does
    # fire it kills an entire descendant cgroup, which can be a whole VSCode
    # window scope. hardware.nix's earlyoom covers the same ground with a much
    # narrower target, so oomd is disabled.
    oomd.enable = false;
  };

  sops.secrets.zerotierNetworks = {
    sopsFile = ../../secrets/network_bridges.yaml;
    key = "zerotier/networks";
  };

  # randamu 的 pixiv refresh token，通过 systemd LoadCredential 注入服务
  sops.secrets.pixivRefreshToken = {
    sopsFile = ../../secrets/randamu.yaml;
    key = "pixiv_refresh_token";
  };

  users.users.maiko.extraGroups = [
    "samba"
    "video"
    "shadow"
  ];
}
