# Git + gh + gh-dash.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs = lib.mkIf config.maiko.hm.git {
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

    # https://github.com/dlvhdr/gh-dash
    gh-dash = {
      enable = true;
      settings = { };
    };
  };
}
