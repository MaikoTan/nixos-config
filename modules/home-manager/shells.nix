{
  config,
  lib,
  pkgs,
  ...
}:

let

  nodejs = pkgs.nodejs_22;
  yarn = pkgs.writeShellScriptBin "yarn" ''
    exec ${nodejs}/bin/corepack yarn@4 "$@"
  '';

in

{

  home.packages = [
    # Node.js and its friends
    nodejs
    yarn
  ]
  ++ (with pkgs; [
    # Miscellaneous tools
    gping
    procs

    # Development tools
    eza
    bat
    fd
    dust
    duf
    sd
  ]);

  programs = {
    bottom = {
      enable = true;
    };

    pnpm = {
      enable = true;
    };

    fish = {
      shellAbbrs = lib.mkIf config.programs.fish.enable {
        # Expanded only when typing interactively; agent-safe (real cmd used otherwise)
        ls = "eza --color=auto --icons";
        ll = "eza --long --header --git --color=auto --icons";
        la = "eza -la --header --git --color=auto --icons";
        tree = "eza --tree --icons";
        cat = "bat --paging=never";
        find = "fd";
        du = "dust";
        df = "duf";
        sed = "sd";
      };
      functions = lib.mkIf config.programs.fish.enable {
        gitignore = "curl -sL https://www.gitignore.io/api/$argv";
      };
    };

    bash.bashrcExtra = lib.mkIf config.programs.bash.enable ''
      gitignore() {
        curl -sL https://www.gitignore.io/api/"$@"
      }
    '';

    zsh.initContent = lib.mkIf config.programs.zsh.enable ''
      gitignore() {
        curl -sL https://www.gitignore.io/api/"$@"
      }
    '';

    ripgrep = {
      enable = true;
    };
  };
}
