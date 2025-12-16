{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # System Utilities
    htop
    rsync
    curl
    wget
    lsof
    # Text
    vim
  ];

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

  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Enable the X11 windowing system.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound.
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };

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

  # KDE Connect integration
  programs = {
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };

    xwayland.enable = true;

    dconf.enable = true;

    fish.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services.displayManager.defaultSession = "gnome";
}
