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
      fcitx5.addons = with pkgs; [
        fcitx5-rime
        fcitx5-mozc
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    fcitx5
    # rime
    fcitx5-rime
    rime-data
    # Rime Schema Repository
    brise

    # GNOME Input Method Panel
    gnomeExtensions.kimpanel
  ];
}
