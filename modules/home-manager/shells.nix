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
      # Use shellAliases with conditional logic: human gets enhanced commands, agents get real commands
      # Agents set COPILOT_AGENT=1 and AI_AGENT=github_copilot_vscode_agent
      shellAliases = lib.mkIf config.programs.fish.enable (
        let
          # Helper to create conditional alias: human gets enhanced, agent gets real command
          mkAlias = enhanced: fallback: ''
            if not set -q COPILOT_AGENT; and not set -q AI_AGENT;
              ${enhanced};
            else;
              command ${fallback};
            end
          '';
        in
        {
          ls = mkAlias "eza --color=auto --icons=auto" "ls";
          ll = mkAlias "eza --long --header --git --color=auto --icons=auto" "ls -l";
          la = mkAlias "eza -la --header --git --color=auto --icons=auto" "ls -la";
          tree = mkAlias "eza --tree --icons=auto" "tree";
          cat = mkAlias "bat --paging=never" "cat";
          find = mkAlias "fd" "find";
          du = mkAlias "dust" "du";
          df = mkAlias "duf" "df";
          sed = mkAlias "sd" "sed";
        }
      );
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
