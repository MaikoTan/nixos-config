# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "com/mattjakeman/ExtensionManager" = {
      last-used-version = "0.5.1";
    };

    "com/uploadedlobster/peek" = {
      persist-save-folder = "/home/maiko/workspaces/cactbot-highlight/images";
      persist-window-geometry = mkTuple [ 305 91 ];
    };

    "org/gabmus/gfeeds" = {
      auto-refresh-enabled = true;
      blocklist-last-update = 1.741829758965503e9;
      dark-mode = false;
      enable-js = true;
      feeds = ''
        {"https://nitter.space/m_daichi_fx_/rss": {}}
      '';
      read-items = "[]";
      window-height = 650;
      window-width = 366;
    };

    "org/gnome/Console" = {
      last-window-maximised = true;
      last-window-size = mkTuple [ 360 294 ];
    };

    "org/gnome/Loupe" = {
      show-properties = true;
    };

    "org/gnome/Totem" = {
      active-plugins = [ "skipto" "autoload-subtitles" "variable-rate" "screenshot" "screensaver" "apple-trailers" "save-file" "mpris" "movie-properties" "rotation" "vimeo" "recent" "open-directory" ];
      subtitle-encoding = "UTF-8";
    };

    "org/gnome/baobab/ui" = {
      active-chart = "rings";
      is-maximized = false;
      window-size = mkTuple [ 960 600 ];
    };

    "org/gnome/calculator" = {
      accuracy = 9;
      angle-units = "degrees";
      base = 2;
      button-mode = "basic";
      number-format = "automatic";
      show-thousands = false;
      show-zeroes = false;
      source-currency = "";
      source-units = "degree";
      target-currency = "";
      target-units = "radian";
      window-maximized = false;
      window-size = mkTuple [ 360 666 ];
      word-size = 64;
    };

    "org/gnome/calendar" = {
      active-view = "month";
      window-maximized = true;
      window-size = mkTuple [ 646 600 ];
    };

    "org/gnome/control-center" = {
      last-panel = "bluetooth";
      window-state = mkTuple [ 980 640 ];
    };

    "org/gnome/desktop/a11y/applications" = {
      screen-reader-enabled = false;
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [ "Utilities" "YaST" "Pardus" ];
    };

    "org/gnome/desktop/app-folders/folders/Pardus" = {
      categories = [ "X-Pardus-Apps" ];
      name = "X-Pardus-Apps.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = [ "gnome-abrt.desktop" "gnome-system-log.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.Dictionary.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.fonts.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop" "vinagre.desktop" ];
      categories = [ "X-GNOME-Utilities" ];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/YaST" = {
      categories = [ "X-SuSE-YaST" ];
      name = "suse-yast.directory";
      translate = true;
    };

    "org/gnome/desktop/background" = {
      primary-color = "#3071AE";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/datetime" = {
      automatic-timezone = false;
    };

    "org/gnome/desktop/input-sources" = {
      mru-sources = [ (mkTuple [ "xkb" "us" ]) ];
      sources = [ (mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "compose:ins" ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-size = 24;
      cursor-theme = "Adwaita";
      enable-animations = true;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "Noto Sans,  10";
      gtk-theme = "Adwaita";
      icon-theme = "breeze-dark";
      scaling-factor = mkUint32 1;
      text-scaling-factor = 1.0;
      toolbar-style = "text";
    };

    "org/gnome/desktop/notifications" = {
      application-children = [ "org-gnome-software" "google-chrome" "org-gnome-console" "todesk" "gimp" "org-gnome-baobab" "org-gnome-nautilus" "firefox" "qq" "gnome-power-panel" "org-gnome-settings" "wemeetapp" "info-mumble-mumble" "com-obsproject-studio" "org-gnome-extensions" "org-kde-spectacle" "libreoffice-calc" "com-alibabainc-dingtalk" "parsecd" ];
    };

    "org/gnome/desktop/notifications/application/com-alibabainc-dingtalk" = {
      application-id = "com.alibabainc.dingtalk.desktop";
    };

    "org/gnome/desktop/notifications/application/com-obsproject-studio" = {
      application-id = "com.obsproject.Studio.desktop";
    };

    "org/gnome/desktop/notifications/application/firefox" = {
      application-id = "firefox.desktop";
    };

    "org/gnome/desktop/notifications/application/gimp" = {
      application-id = "gimp.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/google-chrome" = {
      application-id = "google-chrome.desktop";
    };

    "org/gnome/desktop/notifications/application/info-mumble-mumble" = {
      application-id = "info.mumble.Mumble.desktop";
    };

    "org/gnome/desktop/notifications/application/libreoffice-calc" = {
      application-id = "libreoffice-calc.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-baobab" = {
      application-id = "org.gnome.baobab.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-console" = {
      application-id = "org.gnome.Console.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-extensions" = {
      application-id = "org.gnome.Extensions.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
      application-id = "org.gnome.Nautilus.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-settings" = {
      application-id = "org.gnome.Settings.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-software" = {
      application-id = "org.gnome.Software.desktop";
    };

    "org/gnome/desktop/notifications/application/org-kde-spectacle" = {
      application-id = "org.kde.spectacle.desktop";
    };

    "org/gnome/desktop/notifications/application/parsecd" = {
      application-id = "parsecd.desktop";
    };

    "org/gnome/desktop/notifications/application/qq" = {
      application-id = "qq.desktop";
    };

    "org/gnome/desktop/notifications/application/todesk" = {
      application-id = "todesk.desktop";
    };

    "org/gnome/desktop/notifications/application/wemeetapp" = {
      application-id = "wemeetapp.desktop";
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      speed = 0.0;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///usr/share/backgrounds/gnome/adwaita-l.jxl";
      primary-color = "#3071AE";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/search-providers" = {
      sort-order = [ "org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop" ];
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 300;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = true;
      theme-name = "__custom";
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [ "<Super>Tab" ];
      switch-applications-backward = [ "<Shift><Super>Tab" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,maximize,minimize:icon";
      workspace-names = [];
    };

    "org/gnome/evince/default" = {
      continuous = true;
      dual-page = false;
      dual-page-odd-left = false;
      enable-spellchecking = true;
      fullscreen = false;
      inverted-colors = false;
      show-sidebar = true;
      sidebar-page = "thumbnails";
      sidebar-size = 132;
      sizing-mode = "automatic";
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
    };

    "org/gnome/gnome-system-monitor" = {
      current-tab = "processes";
      maximized = false;
      show-dependencies = false;
      show-whose-processes = "all";
      window-height = 720;
      window-width = 982;
    };

    "org/gnome/gnome-system-monitor/disktreenew" = {
      col-6-visible = true;
      col-6-width = 0;
    };

    "org/gnome/gnome-system-monitor/proctree" = {
      col-26-visible = false;
      col-26-width = 0;
      columns-order = [ 0 1 2 3 4 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 ];
      sort-col = 0;
      sort-order = 0;
    };

    "org/gnome/mutter" = {
      workspaces-only-on-primary = true;
    };

    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "medium";
    };

    "org/gnome/nautilus/list-view" = {
      use-tree-view = false;
    };

    "org/gnome/nautilus/preferences" = {
      date-time-format = "detailed";
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [ 890 550 ];
      initial-size-file-chooser = mkTuple [ 890 550 ];
      maximized = true;
    };

    "org/gnome/portal/filechooser/google-chrome" = {
      last-folder-path = "/home/maiko/Downloads";
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-schedule-automatic = false;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Alt>t";
      command = "kgx";
      name = "Launch Terminal";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "nothing";
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      app-picker-layout = "[{'android-studio.desktop': <{'position': <0>}>, 'org.gnome.Contacts.desktop': <{'position': <1>}>, 'org.gnome.Weather.desktop': <{'position': <2>}>, 'org.gnome.clocks.desktop': <{'position': <3>}>, 'org.gnome.Maps.desktop': <{'position': <4>}>, 'org.kde.ark.desktop': <{'position': <5>}>, 'org.kde.audiotube.desktop': <{'position': <6>}>, 'org.gnome.Totem.desktop': <{'position': <7>}>, 'org.gnome.Calculator.desktop': <{'position': <8>}>, 'bssh.desktop': <{'position': <9>}>, 'org.gnome.Settings.desktop': <{'position': <10>}>, 'bvnc.desktop': <{'position': <11>}>, 'avahi-discover.desktop': <{'position': <12>}>, 'Utilities': <{'position': <13>}>, 'blender-3.6.desktop': <{'position': <14>}>, 'yelp.desktop': <{'position': <15>}>, 'org.gnome.Snapshot.desktop': <{'position': <16>}>, 'cmake-gui.desktop': <{'position': <17>}>, 'com.alibabainc.dingtalk.desktop': <{'position': <18>}>, 'discord.desktop': <{'position': <19>}>, 'com.mattjakeman.ExtensionManager.desktop': <{'position': <20>}>}, {'org.gnome.Extensions.desktop': <{'position': <0>}>, 'org.fcitx.Fcitx5.desktop': <{'position': <1>}>, 'fcitx5-configtool.desktop': <{'position': <2>}>, 'org.fcitx.fcitx5-migrator.desktop': <{'position': <3>}>, 'firefox.desktop': <{'position': <4>}>, 'fish.desktop': <{'position': <5>}>, 'gimp.desktop': <{'position': <6>}>, 'lstopo.desktop': <{'position': <7>}>, 'htop.desktop': <{'position': <8>}>, 'org.inkscape.Inkscape.desktop': <{'position': <9>}>, 'kbd-layout-viewer5.desktop': <{'position': <10>}>, 'org.kde.konsole.desktop': <{'position': <11>}>, 'libreoffice-startcenter.desktop': <{'position': <12>}>, 'libreoffice-base.desktop': <{'position': <13>}>, 'libreoffice-calc.desktop': <{'position': <14>}>, 'libreoffice-draw.desktop': <{'position': <15>}>, 'libreoffice-impress.desktop': <{'position': <16>}>, 'libreoffice-math.desktop': <{'position': <17>}>, 'libreoffice-writer.desktop': <{'position': <18>}>, 'info.mumble.Mumble.desktop': <{'position': <19>}>, 'org.gnome.Epiphany.desktop': <{'position': <20>}>, 'cups.desktop': <{'position': <21>}>, 'netease-cloud-music.desktop': <{'position': <22>}>, 'jconsole-java11-openjdk.desktop': <{'position': <23>}>}, {'jshell-java11-openjdk.desktop': <{'position': <0>}>, 'filezilla.desktop': <{'position': <1>}>, 'virtualbox.desktop': <{'position': <2>}>, 'com.uploadedlobster.peek.desktop': <{'position': <3>}>, 'playonlinux4.desktop': <{'position': <4>}>, 'postman.desktop': <{'position': <5>}>, 'system-config-printer.desktop': <{'position': <6>}>, 'org.rncbc.qpwgraph.desktop': <{'position': <7>}>, 'qq.desktop': <{'position': <8>}>, 'assistant.desktop': <{'position': <9>}>, 'org.ksnip.ksnip.desktop': <{'position': <10>}>, 'designer.desktop': <{'position': <11>}>, 'linguist.desktop': <{'position': <12>}>, 'qdbusviewer.desktop': <{'position': <13>}>, 'qv4l2.desktop': <{'position': <14>}>, 'qvidcap.desktop': <{'position': <15>}>, 'parsecd.desktop': <{'position': <16>}>, 'org.kde.spectacle.desktop': <{'position': <17>}>, 'steam.desktop': <{'position': <18>}>, 'org.gnome.Characters.desktop': <{'position': <19>}>, 'org.gnome.TextEditor.desktop': <{'position': <20>}>, 'todesk.desktop': <{'position': <21>}>, 'org.gnome.Tour.desktop': <{'position': <22>}>, 'transmission-qt.desktop': <{'position': <23>}>}, {'uxterm.desktop': <{'position': <0>}>, 'vim.desktop': <{'position': <1>}>, 'vlc.desktop': <{'position': <2>}>, 'winetricks.desktop': <{'position': <3>}>, 'xterm.desktop': <{'position': <4>}>, 'org.kde.yakuake.desktop': <{'position': <5>}>, 'org.gnome.Calendar.desktop': <{'position': <6>}>, 'org.gnome.Music.desktop': <{'position': <7>}>, 'org.gnome.Software.desktop': <{'position': <8>}>, 'org.gnome.SystemMonitor.desktop': <{'position': <9>}>, 'com.obsproject.Studio.desktop': <{'position': <10>}>, 'org.freedesktop.MalcontentControl.desktop': <{'position': <11>}>, 'wechat-devtools.desktop': <{'position': <12>}>, 'wemeetapp.desktop': <{'position': <13>}>, 'org.gnome.Console.desktop': <{'position': <14>}>, 'org.gnome.SimpleScan.desktop': <{'position': <15>}>, 'org.gabmus.gfeeds.desktop': <{'position': <16>}>, 'org.gnome.font-viewer.desktop': <{'position': <17>}>, 'code-insiders.desktop': <{'position': <18>}>}]";
      command-history = [ "r" ];
      disabled-extensions = [ "window-list@gnome-shell-extensions.gcampax.github.com" "windowsNavigator@gnome-shell-extensions.gcampax.github.com" ];
      enabled-extensions = [ "apps-menu@gnome-shell-extensions.gcampax.github.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "launch-new-instance@gnome-shell-extensions.gcampax.github.com" "auto-move-windows@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com" "dash-to-dock@micxgx.gmail.com" "unite@hardpixel.eu" "native-window-placement@gnome-shell-extensions.gcampax.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "system-monitor@gnome-shell-extensions.gcampax.github.com" "kimpanel@kde.org" "scroll-workspaces@gfxmonk.net" "wallhub@sakithb.github.io" ];
      favorite-apps = [ "google-chrome.desktop" "org.gnome.Nautilus.desktop" "code-insiders.desktop" ];
      welcome-dialog-last-shown-version = "45.4";
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      background-opacity = 0.8;
      dash-max-icon-size = 36;
      dock-position = "BOTTOM";
      height-fraction = 0.7;
      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
      multi-monitor = true;
      preferred-monitor = -2;
      preferred-monitor-by-connector = "HDMI-1";
    };

    "org/gnome/shell/extensions/kimpanel" = {
      vertical = true;
    };

    "org/gnome/shell/extensions/net/gfxmonk/scroll-workspaces" = {
      ignore-last-workspace = true;
      indicator = false;
      scroll-delay = 20;
    };

    "org/gnome/shell/extensions/unite" = {
      hide-activities-button = "auto";
      hide-window-titlebars = "maximized";
      show-window-title = "maximized";
    };

    "org/gnome/shell/extensions/wallhub" = {
      slideshow-interval = mkUint32 10;
      slideshow-interval-unit = "Seconds";
      wallpaper-paths = [ "/home/maiko/Pictures/pixiv" ];
      wallpaper-paths-selected = 1;
    };

    "org/gnome/shell/extensions/window-list" = {
      display-all-workspaces = false;
      show-on-all-monitors = false;
    };

    "org/gnome/shell/world-clocks" = {
      locations = "@av []";
    };

    "org/gnome/software" = {
      check-timestamp = mkInt64 1750906879;
      first-run = false;
      flatpak-purge-timestamp = mkInt64 1750900287;
      install-timestamp = mkInt64 1750207122;
      update-notification-timestamp = mkInt64 1750224059;
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = true;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 140;
      sort-column = "modified";
      sort-directories-first = true;
      sort-order = "ascending";
      type-format = "category";
      view-type = "grid";
      window-size = mkTuple [ 815 746 ];
    };

    "org/gtk/settings/color-chooser" = {
      selected-color = mkTuple [ true 1.0 ];
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 155;
      sort-column = "modified";
      sort-directories-first = false;
      sort-order = "descending";
      type-format = "category";
      window-position = mkTuple [ 412 120 ];
      window-size = mkTuple [ 1096 821 ];
    };

  };
}
