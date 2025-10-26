{ pkgs, ... }:

{
  programs.fish.plugins = [
    {
      name = "yarn-workspace-completion";
      src = pkgs.writeTextDir "completions/yarn.fish" ''
        # Completions for `yarn workspace <TAB>` command
        # It lists all workspaces in the current directory based on the package.json file
        function __fish_yarn_get_workspaces
          if type -q ${pkgs.jq}/bin/jq && test -f package.json
            command \
              # List all workspaces glob patterns in the current workspaces
              ${pkgs.jq}/bin/jq -r '.workspaces | .[]' package.json 2>/dev/null |\
              # list nested package.json files in every glob pattern
              ${pkgs.findutils}/bin/xargs -I {} -- fish -c "ls {}/package.json 2>/dev/null" |\
              # get name of the workspace from the package.json
              ${pkgs.findutils}/bin/xargs -I {} -- fish -c "${pkgs.jq}/bin/jq -r '.name' {} 2>/dev/null" |\
              # remove empty lines
              grep -v '^$' 2>/dev/null |\
              # remove duplicates
              sort -u 2>/dev/null
          end
        end

        complete -f -c yarn -n '__fish_seen_subcommand_from workspace' -a "(__fish_yarn_get_workspaces)"
      '';
    }
  ];
}
