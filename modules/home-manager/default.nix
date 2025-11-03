{ pkgs, wechat-devtools, ... }:

{
  imports = [
    ./vscode/default.nix
    ./fish/default.nix
    ./dconf.nix
    ./gnome.nix
    ./ime.nix
    ./shells.nix
  ];

  home.username = "maiko";
  home.homeDirectory = "/home/maiko";

  home.stateVersion = "24.11";

  home.packages =
    (with pkgs; [
      # System Utilities
      kdePackages.yakuake
      quickemu # Simple CLI virtual machine manager
      # Text
      jq
      yq-go # https://mikefarah.gitbook.io/yq/
      # base16384 # https://github.com/fumiama/base16384
      # Media
      vlc
      # Networks, Browsers, and Communication
      google-chrome
      transmission_4
      # Miscellaneous
      neofetch
    ])
    ++ [
      # Development
      wechat-devtools.packages.x86_64-linux.default
    ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;

    # Enable Git LFS
    lfs.enable = true;

    settings = {
      user.name = "Maiko Tan";
      user.email = "maiko.tan.coding@gmail.com";

      init.defaultBranch = "master";
      user.signingkey = "970A6794990C52AE";
      core = {
        gpgsign = true;
      };

      commit = {
        # Sign commits using GPG.
        gpgsign = true;
      };

      merge = {
        conflictStyle = "diff3";
      };

      url =
        builtins.foldl'
          (
            acc:
            { host, https }:
            acc
            // {
              "${host}" = {
                insteadOf = https;
              };
            }
          )
          { }
          [
            {
              host = "git@github.com:";
              https = "https://github.com/";
            }
            {
              host = "git@gitlab.com:";
              https = "https://gitlab.com/";
            }
            {
              host = "git@e.coding.net:";
              https = "https://e.coding.net/";
            }
            {
              host = "git@ssh.gitgud.io:";
              https = "https://gitgud.io/";
            }
          ];
    };
  };

  programs = {
    gh = {
      enable = true;
      extensions = with pkgs; [
        # https://github.com/github/gh-copilot
        gh-copilot
        # https://github.com/gennaro-tedesco/gh-f
        gh-f
      ];
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };

    # https://github.com/dlvhdr/gh-dash
    gh-dash = {
      enable = true;
      settings = { };
    };
  };

  programs.zoxide = {
    enable = true;
  };

  xsession.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 30 * 60; # 30 minutes
    enableSshSupport = true;
  };
}
