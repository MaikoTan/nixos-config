{ config, lib, pkgs, ... }:

{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-mozc
    ];
  };

  environment.systemPackages = with pkgs; [
    # rime
    fcitx5-rime
    rime-data
  ];
}
