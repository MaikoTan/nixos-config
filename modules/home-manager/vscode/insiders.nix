{
  lib,
  pkgs,
  code-insiders,
  config,
  ...
}:

let

  package = (
    code-insiders.packages."x86_64-linux".vscode-insider.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
    })
  );
  editor = "${package}/bin/code-insiders --wait";

in

{
  programs.vscode = {
    enable = true;
    # isInsiders = true; # No need to set this option since the flake input already set it in their package definition.

    mutableExtensionsDir = true; # Allow VS Code to manage extensions as well as user settings.
    inherit package;
  };

  programs.git.settings = {
    core = {
      inherit editor;
    };
  };

  programs.gh.settings = {
    inherit editor;
  };
}
