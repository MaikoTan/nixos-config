{ pkgs, code-insiders, ... }:

{
  programs.vscode = {
    enable = true;
    # isInsiders = true; # No need to set this option since the flake input already set it in their package definition.
    enableExtensionUpdateCheck = false;
    package = (code-insiders.packages."x86_64-linux".vscode-insider.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
    }));
  };
}
