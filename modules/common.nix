{ pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # System Utilities
    htop
    rsync
    wget
    # Text
    vim
    # Fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    roboto-mono
    jetbrains-mono
    ubuntu_font_family
    fira-code
    fira-code-symbols
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  programs.dconf.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
}
