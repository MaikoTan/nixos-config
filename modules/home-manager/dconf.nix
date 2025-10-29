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
      persist-window-geometry = mkTuple [ 305 91 993 675 ];
    };

    "org/gabmus/gfeeds" = {
      auto-refresh-enabled = true;
      blocklist-last-update = 1.741829758965503e9;
      dark-mode = false;
      enable-js = true;
      feeds = ''
        {"https://nitter.space/m_daichi_fx_/rss": {}}\\n\n
      '';
      read-items = "[]";
      window-height = 650;
      window-width = 366;
    };

    "org/gnome/Console" = {
      custom-font = "FiraCode Nerd Font Mono 10";
      font-scale = 1.0;
      ignore-scrollback-limit = true;
      last-window-maximised = true;
      last-window-size = mkTuple [ 360 294 ];
      theme = "night";
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
      last-panel = "network";
      window-state = mkTuple [ 760 510 false ];
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
      picture-options = "zoom";
      primary-color = "#3071AE";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/break-reminders/eyesight" = {
      play-sound = true;
    };

    "org/gnome/desktop/break-reminders/movement" = {
      duration-seconds = mkUint32 300;
      interval-seconds = mkUint32 1800;
      play-sound = true;
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
      application-children = [ "org-gnome-software" "google-chrome" "org-gnome-console" "todesk" "gimp" "org-gnome-baobab" "org-gnome-nautilus" "firefox" "qq" "gnome-power-panel" "org-gnome-settings" "wemeetapp" "info-mumble-mumble" "com-obsproject-studio" "org-gnome-extensions" "org-kde-spectacle" "libreoffice-calc" "com-alibabainc-dingtalk" "parsecd" "org-gnome-shell-extensions" "org-gnome-shell-extensions-gsconnect" "virtualbox" "clash-verge" "gnome-about-panel" ];
    };

    "org/gnome/desktop/notifications/application/clash-verge" = {
      application-id = "Clash Verge.desktop";
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

    "org/gnome/desktop/notifications/application/gnome-about-panel" = {
      application-id = "gnome-about-panel.desktop";
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

    "org/gnome/desktop/notifications/application/org-gnome-shell-extensions-gsconnect" = {
      application-id = "org.gnome.Shell.Extensions.GSConnect.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-shell-extensions" = {
      application-id = "org.gnome.Shell.Extensions.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-software" = {
      application-id = "org.gnome.Software.desktop";
    };

    "org/gnome/desktop/notifications/application/org-kde-spectacle" = {
      application-id = "org.kde.spectacle.desktop";
    };

    "org/gnome/desktop/notifications/application/org-remmina-remmina" = {
      application-id = "org.remmina.Remmina.desktop";
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

    "org/gnome/desktop/notifications/application/virtualbox" = {
      application-id = "virtualbox.desktop";
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

    "org/gnome/desktop/remote-desktop/rdp" = {
      enable = false;
      tls-cert = "/home/maiko/.local/share/gnome-remote-desktop/certificates/rdp-tls.crt";
      tls-key = "/home/maiko/.local/share/gnome-remote-desktop/certificates/rdp-tls.key";
      view-only = true;
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      primary-color = "#3071AE";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/search-providers" = {
      sort-order = [ "org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop" ];
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = false;
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
      sort-col = 8;
      sort-order = 0;
    };

    "org/gnome/mutter" = {
      workspaces-only-on-primary = true;
    };

    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "medium";
    };

    "org/gnome/nautilus/list-view" = {
      default-zoom-level = "large";
      use-tree-view = false;
    };

    "org/gnome/nautilus/preferences" = {
      date-time-format = "detailed";
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
      show-delete-permanently = true;
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [ 890 550 ];
      initial-size-file-chooser = mkTuple [ 890 550 ];
      maximized = false;
    };

    "org/gnome/nm-applet/eap/0e18a83a-7255-3371-b689-a4dd3427eacd" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/90f4dba0-d7f6-448e-9d13-5c1325b2fd96" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/cf3130d0-f073-415a-8426-fcbf1b10ed78" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/portal/filechooser/com/google/Chrome" = {
      last-folder-path = "/home/maiko/Downloads";
    };

    "org/gnome/portal/filechooser/google-chrome" = {
      last-folder-path = "/home/maiko/Downloads";
    };

    "org/gnome/portal/filechooser/virtualbox" = {
      last-folder-path = "/home/maiko/workspaces/nixos-config/result";
    };

    "org/gnome/settings-daemon/global-shortcuts" = {
      applications = [ "com.google.Chrome" ];
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-schedule-automatic = false;
    };

    "org/gnome/settings-daemon/plugins/housekeeping" = {
      donation-reminder-last-shown = mkInt64 1758610629103889;
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
      command-history = [ "r" "lg" ];
      disable-user-extensions = false;
      disabled-extensions = [ "window-list@gnome-shell-extensions.gcampax.github.com" "windowsNavigator@gnome-shell-extensions.gcampax.github.com" "status-icons@gnome-shell-extensions.gcampax.github.com" "backslide@codeisland.org" ];
      enabled-extensions = [ "apps-menu@gnome-shell-extensions.gcampax.github.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "launch-new-instance@gnome-shell-extensions.gcampax.github.com" "auto-move-windows@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com" "dash-to-dock@micxgx.gmail.com" "unite@hardpixel.eu" "native-window-placement@gnome-shell-extensions.gcampax.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "system-monitor@gnome-shell-extensions.gcampax.github.com" "kimpanel@kde.org" "scroll-workspaces@gfxmonk.net" "blur-my-shell@aunetx" "gsconnect@andyholmes.github.io" "wallhub@sakithb.github.io" "appindicatorsupport@rgcjonas.gmail.com" ];
      favorite-apps = [ "google-chrome.desktop" "org.gnome.Nautilus.desktop" "code-insiders.desktop" ];
      welcome-dialog-last-shown-version = "45.4";
    };

    "org/gnome/shell/extensions/appindicator" = {
      icon-brightness = 0.0;
      icon-contrast = 0.0;
      icon-opacity = 240;
      icon-saturation = 0.0;
      icon-size = 0;
    };

    "org/gnome/shell/extensions/backslide" = {
      elapsed-time = 1;
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      settings-version = 2;
    };

    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      brightness = 0.6;
      sigma = 30;
    };

    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = true;
      blur-on-overview = true;
      brightness = 0.75;
      dynamic-opacity = false;
      opacity = 235;
      sigma = 0;
      whitelist = [ "kgx" "Code - Insiders" "org.remmina.Remmina" "org.gnome.Console" ];
    };

    "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = true;
      brightness = 0.6;
      pipeline = "pipeline_default_rounded";
      sigma = 30;
      static-blur = true;
      style-dash-to-dock = 0;
    };

    "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      brightness = 0.6;
      pipeline = "pipeline_default";
      sigma = 30;
    };

    "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/window-list" = {
      brightness = 0.6;
      sigma = 30;
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

    "org/gnome/shell/extensions/gsconnect" = {
      devices = [ "8434dc07a4584327b1ad4956050c45ad" ];
      enabled = true;
      keep-alive-when-locked = true;
      missing-openssl = false;
      name = "c-arch";
      show-indicators = true;
    };

    "org/gnome/shell/extensions/gsconnect/device/8434dc07a4584327b1ad4956050c45ad" = {
      certificate-pem = "-----BEGIN CERTIFICATE-----nMIIDFzCCAf+gAwIBAgIBATANBgkqhkiG9w0BAQ0FADBPMSkwJwYDVQQDDCA4NDM0nZGMwN2E0NTg0MzI3YjFhZDQ5NTYwNTBjNDVhZDEUMBIGA1UECwwLS0RFIENvbm5lnY3QxDDAKBgNVBAoMA0tERTAeFw0yNDA0MTIxNjAwMDBaFw0zNTA0MTIxNjAwMDBanME8xKTAnBgNVBAMMIDg0MzRkYzA3YTQ1ODQzMjdiMWFkNDk1NjA1MGM0NWFkMRQwnEgYDVQQLDAtLREUgQ29ubmVjdDEMMAoGA1UECgwDS0RFMIIBIjANBgkqhkiG9w0BnAQEFAAOCAQ8AMIIBCgKCAQEAsF3w0fBMax0FXv8PGnrV0u5gCxNX5KE3iJmO791unnHce6A7gELBqRYA7DrFb3apE1yQWieZk5vITmqHNgWm/5NX7z8ts/4R9pKa75HZLnfwcf8Zv8DgI0i75bRP8L9y+iIpcUmetf6xD5NiEoiX/N+m6N57KItCDGoKmTPkmfniVfdFLwap6i9ba/RxxH6wgDNsXngUlViUXyXH7YE9M2ULr5t4eBBqMRUNCqiGHAgnNXrHzE5NcyG75r61dMeplZo+O0DHT4kqLWXah981dX6eIw/uKbYmrCJle5dbY5zjnd5n7pr8qKUFVVyI7iNN3TMUcvkw/52ImVnqnfouqoSiv/QIDAQABMA0GCSqGSIb3nDQEBDQUAA4IBAQCLmJIqIGlA0L19DY0hjTNM7aQZLVQxK25AGrk7bpEPl/3x5xpDnpRWLzoUtbVjbfVX3ewDFyzrMYAEfmHDy+z14De8mG+iujsFPlflX+BrXyxHAAr25nLjBumwuTQvSckiMNC5oqT0tbXhKSYFwD/ifkAMLIbdm7wJFkZ9epBTwU4Y0VKeNAn9/hLvjIAggadpYbnudkm17icibTHTPRd3jK5cQ65x66TfNQ3CoWOVoUG3ST+i5hmnbLIAg9fWYwIsV9FU4X0Gsj889iIJSOiCwjaLS0WYxTQHZe0qmsJCaaY/updls9hZnW4jhKDw4SR4JTd4/kJdkLlzCRKCt7g/LBWkWn-----END CERTIFICATE-----n";
      incoming-capabilities = [ "kdeconnect.battery" "kdeconnect.bigscreen.stt" "kdeconnect.clipboard" "kdeconnect.clipboard.connect" "kdeconnect.contacts.request_all_uids_timestamps" "kdeconnect.contacts.request_vcards_by_uid" "kdeconnect.findmyphone.request" "kdeconnect.mousepad.keyboardstate" "kdeconnect.mousepad.request" "kdeconnect.mpris" "kdeconnect.mpris.request" "kdeconnect.notification" "kdeconnect.notification.action" "kdeconnect.notification.reply" "kdeconnect.notification.request" "kdeconnect.ping" "kdeconnect.runcommand" "kdeconnect.sftp.request" "kdeconnect.share.request" "kdeconnect.share.request.update" "kdeconnect.sms.request" "kdeconnect.sms.request_attachment" "kdeconnect.sms.request_conversation" "kdeconnect.sms.request_conversations" "kdeconnect.systemvolume" "kdeconnect.telephony.request" "kdeconnect.telephony.request_mute" ];
      last-connection = "lan://192.168.148.197:1716";
      name = "M2007J3SC";
      outgoing-capabilities = [ "kdeconnect.battery" "kdeconnect.bigscreen.stt" "kdeconnect.clipboard" "kdeconnect.clipboard.connect" "kdeconnect.connectivity_report" "kdeconnect.contacts.response_uids_timestamps" "kdeconnect.contacts.response_vcards" "kdeconnect.findmyphone.request" "kdeconnect.mousepad.echo" "kdeconnect.mousepad.keyboardstate" "kdeconnect.mousepad.request" "kdeconnect.mpris" "kdeconnect.mpris.request" "kdeconnect.notification" "kdeconnect.notification.request" "kdeconnect.ping" "kdeconnect.presenter" "kdeconnect.runcommand.request" "kdeconnect.sftp" "kdeconnect.share.request" "kdeconnect.sms.attachment_file" "kdeconnect.sms.messages" "kdeconnect.systemvolume.request" "kdeconnect.telephony" ];
      paired = true;
      supported-plugins = [ "battery" "clipboard" "connectivity_report" "contacts" "findmyphone" "mousepad" "mpris" "notification" "ping" "presenter" "runcommand" "sftp" "share" "sms" "systemvolume" "telephony" ];
      type = "phone";
    };

    "org/gnome/shell/extensions/gsconnect/device/8434dc07a4584327b1ad4956050c45ad/plugin/battery" = {
      custom-battery-notification = true;
      custom-battery-notification-value = mkUint32 80;
      full-battery-notification = true;
    };

    "org/gnome/shell/extensions/gsconnect/device/8434dc07a4584327b1ad4956050c45ad/plugin/clipboard" = {
      receive-content = true;
      send-content = true;
    };

    "org/gnome/shell/extensions/gsconnect/device/8434dc07a4584327b1ad4956050c45ad/plugin/mousepad" = {
      share-control = true;
    };

    "org/gnome/shell/extensions/gsconnect/device/8434dc07a4584327b1ad4956050c45ad/plugin/notification" = {
      applications = ''
        {}
      '';
    };

    "org/gnome/shell/extensions/gsconnect/device/8434dc07a4584327b1ad4956050c45ad/plugin/share" = {
      receive-directory = "/home/maiko/Downloads";
    };

    "org/gnome/shell/extensions/gsconnect/preferences" = {
      window-maximized = false;
      window-size = mkTuple [ 733 460 ];
    };

    "org/gnome/shell/extensions/kimpanel" = {
      vertical = true;
    };

    "org/gnome/shell/extensions/net/gfxmonk/scroll-workspaces" = {
      ignore-last-workspace = true;
      indicator = false;
      scroll-delay = 20;
    };

    "org/gnome/shell/extensions/system-monitor" = {
      show-swap = false;
    };

    "org/gnome/shell/extensions/unite" = {
      hide-activities-button = "auto";
      hide-window-titlebars = "maximized";
      show-window-title = "maximized";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "";
    };

    "org/gnome/shell/extensions/wallhub" = {
      slideshow-interval = mkUint32 30;
      slideshow-interval-unit = "Seconds";
      wallpaper-paths = [ "/home/maiko/Pictures/pixiv" ];
      wallpaper-paths-selected = 1;
    };

    "org/gnome/shell/extensions/window-list" = {
      display-all-workspaces = false;
      show-on-all-monitors = false;
    };

    "org/gnome/shell/extensions/workspace-indicator" = {
      embed-previews = false;
    };

    "org/gnome/shell/world-clocks" = {
      locations = [];
    };

    "org/gnome/software" = {
      check-timestamp = mkInt64 1758855618;
      first-run = false;
      flatpak-purge-timestamp = mkInt64 1758851831;
      install-timestamp = mkInt64 1756947325;
      update-notification-timestamp = mkInt64 1757041696;
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/gtk/gtk4/settings/debug" = {
      inspector-warning = true;
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
      selected-color = mkTuple [ true 1.0 1.0 1.0 1.0 ];
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
      window-position = mkTuple [ 26 23 ];
      window-size = mkTuple [ 1096 821 ];
    };

  };
}
