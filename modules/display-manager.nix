{ config, lib, pkgs, ... }:

let
  cfg = config.maiko.display-manager;
in

{
  options.maiko.display-manager.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable SDDM and Plasma6 desktop";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm.enable = true;
    # services.displayManager.gdm.enable = true;
    services.desktopManager.plasma6.enable = true;
    # services.desktopManager.gnome.enable = true;
    services.displayManager.defaultSession = "plasma";

    # Exclude unwanted KDE applications
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      elisa # Music player
    ];

    # Exclude unwanted GNOME applications
    environment.gnome.excludePackages = with pkgs; [
      baobab # Disk usage analyzer
      epiphany # Web browser
      evince # Document viewer
      gedit # Text editor
      gnome-calculator # Calculator
      gnome-calendar # Calendar
      gnome-characters # Character map
      gnome-clocks # Clocks
      gnome-contacts # Contacts
      gnome-maps # Maps
      gnome-music # Music
      gnome-photos # Photos
      gnome-software # Software
      gnome-weather # Weather
      simple-scan # Scanner
      totem # Video player
      yelp # Help documentation
    ];
  };
}