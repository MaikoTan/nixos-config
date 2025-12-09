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
  # Useful shell aliases or functions
  home.shellAliases = {
    # ----- ls replacements -----
    ls = "${pkgs.eza}/bin/eza --color=auto --icons";
    ll = "${pkgs.eza}/bin/eza --long --header --git --color=auto --icons";
    la = "${pkgs.eza}/bin/eza -la --header --git --color=auto --icons";
    tree = "${pkgs.eza}/bin/eza --tree --icons";

    # ----- cat replacement -----
    cat = "${pkgs.bat}/bin/bat --paging=never";

    # ----- find replacement -----
    find = "${pkgs.fd}/bin/fd";

    # ----- grep replacement -----
    grep = "${pkgs.ripgrep}/bin/rg --color=auto";

    # ----- du / df replacements -----
    du = "${pkgs.dust}/bin/dust";
    df = "${pkgs.duf}/bin/duf";

    # ----- sed replacement -----
    sed = "${pkgs.sd}/bin/sd";

    # ----- diff replacement -----
    diff = "${pkgs.diff-so-fancy}/bin/diff-so-fancy";

    # ----- cd replacement (zoxide) -----
    cd =
      let
        cfg = config.programs.zoxide;
      in
      lib.mkIf (
        cfg.enable && (cfg.enableBashIntegration || cfg.enableZshIntegration || cfg.enableFishIntegration)
      ) "z";

    # ----- misc / quality of life -----
    top = "${pkgs.bottom}/bin/btm"; # fancy top replacement
    ps = "${pkgs.procs}/bin/procs"; # pretty process viewer
    ping = "${pkgs.gping}/bin/gping"; # ping with graph
  };

  home.packages = [
    nodejs
    yarn
    pnpm
  ];

  programs.fish.functions = lib.mkIf config.programs.fish.enable {
    gitignore = "curl -sL https://www.gitignore.io/api/$argv";
  };

  programs.bash.bashrcExtra = lib.mkIf config.programs.bash.enable ''
    gitignore() {
      curl -sL https://www.gitignore.io/api/"$@"
    }
  '';

  programs.zsh.initContent = lib.mkIf config.programs.zsh.enable ''
    gitignore() {
      curl -sL https://www.gitignore.io/api/"$@"
    }
  '';
}
