{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.maiko.display-manager;
in

{
  options.maiko.display-manager.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable SDDM and Plasma6 desktop";
  };

  config = lib.mkIf cfg.enable {
    services = {
      displayManager = {
        sddm.enable = true;
        autoLogin = {
          enable = true;
          user = "maiko";
        };
        defaultSession = "plasma";
      };
      desktopManager = {
        plasma6.enable = true;
      };
    };

    # Exclude unwanted KDE applications
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      elisa # Music player
    ];

    # Exclude unwanted GNOME applications
    environment.gnome.excludePackages = with pkgs; [
      baobab # Disk usage analyzer
      epiphany # Web browser
      evince # Document viewer
      gedit # Text editor
      gnome-calculator # Calculator
      gnome-calendar # Calendar
      gnome-characters # Character map
      gnome-clocks # Clocks
      gnome-contacts # Contacts
      gnome-maps # Maps
      gnome-music # Music
      gnome-photos # Photos
      gnome-software # Software
      gnome-weather # Weather
      simple-scan # Scanner
      totem # Video player
      yelp # Help documentation
    ];

    # sddm-autologin 创建的会话不会触发 logind 的设备分配，
    # 导致 KWin 拿不到 DRM master，进而 screencast 无节点、KRDP 推流失败。
    # 现在已修正 autologin，logind 正确分配 seat0/DRM，KWin 用默认 backend 即可。
    # 保留 DeviceAllow 作为保险。
    systemd.user.units."plasma-kwin_wayland.service" = {
      text = ''
        [Unit]
        Description=KDE Wayland Compositor
        PartOf=graphical-session.target

        [Service]
        ExecStart=${lib.getBin pkgs.kdePackages.kwin}/bin/kwin_wayland_wrapper --xwayland
        BusName=org.kde.KWinWrapper
        Slice=session.slice
        DeviceAllow=/dev/dri/card0 rw
        DeviceAllow=/dev/dri/card1 rw
        DeviceAllow=/dev/dri/renderD128 rw
      '';
    };
  };
}
