{ pkgs, ... }:

{
  imports =
    [
      ./vscode/default.nix
      ./dconf.nix
      ./gnome.nix
      ./ime.nix
    ];

  home.username = "maiko";
  home.homeDirectory = "/home/maiko";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # System Utilities
    htop
    rsync
    libsForQt5.yakuake
    jq
    yq
    # Media
    vlc
    # Documents
    libreoffice-fresh
    # Networks, Browsers, and Communication
    google-chrome
    transmission_4
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Maiko Tan";
    userEmail = "maiko.tan.coding@gmail.com";

    # Enable Git LFS
    lfs.enable = true;

    extraConfig = {
      init.defaultBranch = "master";
      core = {
        # Use VSCode as the default editor.
        editor = "${pkgs.vscode}/bin/code-insiders --wait";

        gpgsign = true;
      };

      commit = {
        # Sign commits using GPG.
        gpgsign = true;
      };

      merge = {
        conflictStyle = "diff3";
      };

      url = {
        # Use SSH instead of HTTPS.
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
        "git@gitlab.com:" = {
          insteadOf = "https://gitlab.com/";
        };
        "git@e.coding.net:" = {
          insteadOf = "https://e.coding.net/";
        };
      };
    };
  };

  xsession.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
