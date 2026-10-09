{
  inputs,
  pkgs,
  ...
}:

let

  package = inputs.code-insiders.packages."x86_64-linux".vscode-insider.overrideAttrs (oldAttrs: {
    # Make VS Code the default editor for Git and GitHub CLI when using git or gh commands in the VS Code terminal.
    preFixup = (oldAttrs.preFixup or "") + ''
      gappsWrapperArgs+=(
        --set GIT_EDITOR "$out/bin/code-insiders --wait"
        --set GIT_SEQUENCE_EDITOR "$out/bin/code-insiders --wait"
        --set GH_EDITOR "$out/bin/code-insiders --wait"
      )
    '';
  });

in

{
  programs = {
    vscode = {
      enable = true;
      # isInsiders = true; # No need to set this option since the flake input already set it in their package definition.

      mutableExtensionsDir = true; # Allow VS Code to manage extensions as well as user settings.
      inherit package;
    };
  };
}
