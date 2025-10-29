{ pkgs, ... }:

{
  home.file.".config/fish/completions/yarn-workspace.fish".text = ''
    # Completions for `yarn workspace <TAB>` command
    function __fish_yarn_get_workspaces
      if test -f package.json
        command \
          # List all workspaces glob patterns in the current workspaces
          yarn workspaces list --json | \
          # Extract the workspace names from the JSON output
          ${pkgs.jq}/bin/jq -r '.[].name'
      end
    end

    complete -f -c yarn -n '__fish_seen_subcommand_from workspace' -a "(__fish_yarn_get_workspaces)"
  '';
}
