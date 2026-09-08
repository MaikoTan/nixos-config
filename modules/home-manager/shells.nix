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
  pnpm = pkgs.writeShellScriptBin "pnpm" ''
    exec ${nodejs}/bin/corepack pnpm@latest "$@"
  '';

in

{

  home.packages = [
    # Node.js and its friends
    nodejs
    yarn
    pnpm
  ]
  ++ (with pkgs; [
    # Miscellaneous tools
    bottom
    gping
    procs

    ripgrep
    zoxide
  ]);

  programs = {
    fish = {
      shellAbbrs = lib.mkIf config.programs.fish.enable {
        # Expanded only when typing interactively; agent-safe (real cmd used otherwise)
        ls = "${pkgs.eza}/bin/eza --color=auto --icons";
        ll = "${pkgs.eza}/bin/eza --long --header --git --color=auto --icons";
        la = "${pkgs.eza}/bin/eza -la --header --git --color=auto --icons";
        tree = "${pkgs.eza}/bin/eza --tree --icons";
        cat = "${pkgs.bat}/bin/bat --paging=never";
        find = "${pkgs.fd}/bin/fd";
        du = "${pkgs.dust}/bin/dust";
        df = "${pkgs.duf}/bin/duf";
        sed = "${pkgs.sd}/bin/sd";
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
  };
}
