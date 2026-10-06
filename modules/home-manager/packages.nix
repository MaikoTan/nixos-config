# Home packages (desktop + android optionals).
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  home.packages =
    (lib.optionals config.maiko.hm.desktop (
      with pkgs;
      [
        # Remote Desktop and Screen Sharing
        # parsec-bin
        # System Utilities
        kdePackages.yakuake
        kdePackages.ark
        unrar
        p7zip-rar
        quickemu # Simple CLI virtual machine manager
        # Text
        yq-go # https://mikefarah.gitbook.io/yq/
        # base16384 # https://github.com/fumiama/base16384
        # Media
        vlc
        inkscape
        # Networks, Browsers, and Communication
        google-chrome
        transmission_4
        freedownloadmanager
        # Miscellaneous
        xc
        # Development
        inputs.wechat-devtools.packages.x86_64-linux.default
      ]
    ))
    ++ (lib.optionals config.maiko.hm.android [
      pkgs.android-tools
      pkgs.android-studio
    ]);
}
