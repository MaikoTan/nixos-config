{
  inputs,
  config,
  osConfig,
  pkgs,
  ...
}:

{
  imports = [
    inputs.android-nixpkgs.hmModule
    ./vscode/default.nix
    ./fish/default.nix
    ./dconf.nix
    ./gnome.nix
    ./ime.nix
    ./shells.nix
  ];

  home = {
    username = "maiko";
    homeDirectory = "/home/maiko";

    stateVersion = "25.11";

    packages =
      (with pkgs; [
        # System Utilities
        kdePackages.yakuake
        kdePackages.ark
        quickemu # Simple CLI virtual machine manager
        # Text
        jq
        yq-go # https://mikefarah.gitbook.io/yq/
        # base16384 # https://github.com/fumiama/base16384
        # Media
        vlc
        inkscape
        # Networks, Browsers, and Communication
        google-chrome
        transmission_4
        # Miscellaneous
        fastfetch
        xc
        github-copilot-cli # https://github.com/github/copilot-cli
      ])
      ++ [
        # Development
        inputs.wechat-devtools.packages.x86_64-linux.default
        pkgs.android-tools
        pkgs.android-studio
      ];
  };

  android-sdk = {
    enable = true;
    path = "${config.home.homeDirectory}/.android/sdk";
    packages =
      sdk: with sdk; [
        build-tools-36-1-0
        cmdline-tools-latest
        emulator
        system-images-android-36-google-apis-x86-64
        platforms-android-36
        sources-android-36
      ];
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;

      # Enable Git LFS
      lfs.enable = true;

      settings = {
        user = {
          name = "Maiko Tan";
          email = "maiko.tan.coding@gmail.com";
          signingkey = "970A6794990C52AE";
        };

        init.defaultBranch = "master";
        core = {
          gpgsign = true;
          pager = "${pkgs.diff-so-fancy}/bin/diff-so-fancy | ${pkgs.less}/bin/less --tabs=4 -RFX";
        };
        interactive.diffFilter = "${pkgs.diff-so-fancy}/bin/diff-so-fancy --patch";

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

    gh = {
      enable = true;
      extensions = with pkgs; [
        # https://github.com/gennaro-tedesco/gh-f
        gh-f
      ];
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };
  };

  home.sessionVariablesExtra = ''
    export GH_TOKEN="$(cat ${osConfig.sops.secrets.companyGitHubToken.path})"
  '';

  # https://github.com/dlvhdr/gh-dash
  programs.gh-dash = {
    enable = true;
    settings = { };
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
