{ config, lib, pkgs, ... }:

{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
    ];
  };

  # setup rime chinese input
  programs.rime = {
    enable = true;
    defaultInputMethod = "rime";
    defaultInputMethodOptions = {
      schema = "luna_pinyin_simp";
    };
  };
}
