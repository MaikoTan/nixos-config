{ pkgs, ... }:

{
  i18n = {
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "es_ES.UTF-8/UTF-8"
      "fr_FR.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
      "ko_KR.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
      "zh_TW.UTF-8/UTF-8"
    ];
    inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-rime
          fcitx5-configtool
        ];
        settings = {
          inputMethod = {
            "Groups/0" = {
            "Name"="Default";
            # Layout
            "Default Layout"="us";
            # Default Input Method
            "DefaultIM"="rime";
            };
            "Groups/0/Items/0" = {
              "Name"="keyboard-us";
            };
            "Groups/0/Items/1" = {
              "Name" = "keyboard-us-carpalx-altgr-intl";
            };
            "Groups/0/Items/2" = {
              "Name" = "keyboard-us-dvp";
            };
            "Groups/0/Items/3" = {
              "Name" = "keyboard-fr";
            };
            "Groups/0/Items/4" = {
              "Name" = "keyboard-de";
            };
            "Groups/0/Items/5" = {
              "Name" = "rime";
            };
            "GroupOrder" = {
              "0"="Default";
            };
          };
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # fcitx5
    # # rime
    # fcitx5-rime
    rime-data
    # Rime Schema Repository
    brise

    # GNOME Input Method Panel
    gnomeExtensions.kimpanel
  ];
}
