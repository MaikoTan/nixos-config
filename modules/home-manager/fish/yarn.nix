{ pkgs, ... }:

{
  # Ensure jq and xargs are installed
  environment.systemPackages = with pkgs; [
    jq
    findutils # Provides `xargs`
    # grep and sort should already provided by coreutils that is installed by default
  ];

  xdg.configFile.fishCompletionYarn = {
    executable = true;
    target = "fish/completions/yarn.fish";
    text = ''
      # Completions for `yarn workspace <TAB>` command
      # It lists all workspaces in the current directory based on the package.json file
      function __fish_yarn_get_workspaces
        if type -q jq && test -f package.json
          command \
            # List all workspaces glob patterns in the current workspaces
            jq -r '.workspaces | .[]' package.json 2>/dev/null |\
            # list nested package.json files in every glob pattern
            xargs -I {} -- fish -c "ls {}/package.json 2>/dev/null" |\
            # get name of the workspace from the package.json
            xargs -I {} -- fish -c "jq -r '.name' {} 2>/dev/null" |\
            # remove empty lines
            grep -v '^$' 2>/dev/null |\
            # remove duplicates
            sort -u 2>/dev/null
        end
      end

      complete -f -c yarn -n '__fish_seen_subcommand_from workspace' -a "(__fish_yarn_get_workspaces)"
    '';
  };
}
