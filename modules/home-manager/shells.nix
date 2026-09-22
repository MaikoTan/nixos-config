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
      # Use functions with conditional logic: human gets enhanced commands, agents get real commands
      # Agents set COPILOT_AGENT=1 and AI_AGENT=github_copilot_vscode_agent
      # Note: shellAliases can't hold multi-line values — fish's `alias` appends `$argv` after the
      # value, which lands standalone after the if/end block and errors when called with no args
      functions = lib.mkIf config.programs.fish.enable (
        let
          # Helper to create conditional function: human gets enhanced, agent gets real command
          mkFn = enhanced: fallback: ''
            if not set -q COPILOT_AGENT; and not set -q AI_AGENT;
              ${enhanced} $argv
            else;
              command ${fallback} $argv
            end
          '';
        in
        {
          ls = mkFn "eza --color=auto --icons=auto" "ls";
          ll = mkFn "eza --long --header --git --color=auto --icons=auto" "ls -l";
          la = mkFn "eza -la --header --git --color=auto --icons=auto" "ls -la";
          tree = mkFn "eza --tree --icons=auto" "tree";
          cat = mkFn "bat --paging=never" "cat";
          find = mkFn "fd" "find";
          du = mkFn "dust" "du";
          df = mkFn "duf" "df";
          sed = mkFn "sd" "sed";
          gitignore = "curl -sL https://www.gitignore.io/api/$argv";
        }
      );
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
