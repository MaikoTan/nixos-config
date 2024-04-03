{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.dash-to-dock-animator
    gnomeExtensions.unite
    gnome.gnome-tweaks
  ];
}
