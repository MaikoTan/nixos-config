{ pkgs, code-insiders, ... }:

{
  programs.vscode = {
    enable = true;
    isInsiders = true;
    enableExtensionUpdateCheck = false;
    package = (code-insiders.packages."x86_64-linux".vscode-insider.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
    }));
  };
}
