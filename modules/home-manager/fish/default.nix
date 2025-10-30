{ config, lib, pkgs, ... }:

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
  imports = [
    ./prompt.nix
    ./ssh-agent.nix
    ./yarn.nix
  ];

  programs.fish = {
    enable = true;

    functions = {
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };

    shellAliases = {
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
      cd = lib.mkIf (
        config.programs.zoxide.enable && config.programs.zoxide.enableFishIntegration
      ) "z";

      # ----- misc / quality of life -----
      top = "${pkgs.bottom}/bin/btm"; # fancy top replacement
      ps = "${pkgs.procs}/bin/procs"; # pretty process viewer
      ping = "${pkgs.gping}/bin/gping"; # ping with graph

      # ----- development -----
      node = "${nodejs}/bin/node";
      npm = "${nodejs}/bin/npm";
      npx = "${nodejs}/bin/npx";
      corepack = "${nodejs}/bin/corepack";
    };
  };

  home.packages = [ yarn pnpm ];

  # Enable zoxide fish integration only if zoxide is enabled
  programs.zoxide.enableFishIntegration = lib.mkIf config.programs.zoxide.enable true;
}
