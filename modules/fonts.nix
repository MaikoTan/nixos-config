{ config, lib, pkgs, ... }:

let
  cfg = config.maiko.fonts;
in

{
  options.maiko.fonts.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable fonts";
  };

  config = lib.mkIf cfg.enable {
    # Fonts
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      roboto-mono
      jetbrains-mono
      ubuntu-classic
      nerd-fonts.fira-code
      fira-code
      fira-code-symbols
      # Microsoft Fonts
      corefonts
      vista-fonts
      vista-fonts-cht # Traditional Chinese
      vista-fonts-chs # Simplified Chinese
    ];
  };
}