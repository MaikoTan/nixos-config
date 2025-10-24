{ pkgs, ... }:

{
  home.packages =
    with pkgs;
    lib.mkMerge [
      (with gnomeExtensions; [
        blur-my-shell # Blur effect for GNOME Shell
        gsconnect # KDE Connect integration
        dash-to-dock # Dock
        unite # Window management
        wallhub # Wallpaper changer
      ])
      [
        gnome-shell-extensions # Core GNOME Shell extensions
        gnome-tweaks
        dconf
        # Several useful desktop applications
        remmina # remote desktop client
      ]
    ];
}
