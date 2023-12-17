{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    package = (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
      src = (builtins.fetchTarball {
        url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
        sha256 = "023ryfx9zj7d7ghh41xixsz3yyngc2y6znkvfsrswcij67jqm8cd";
      });
      version = "latest";

      buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
    });
  
    extensions = with pkgs.vscode-extensions; [
      WakaTime.vscode-wakatime
      rust-lang.rust-analyzer
      jnoortheen.nix-ide
      eamodio.gitlens
      github.copilot
      bbenoist.nix
      mkhl.direnv
      golang.go
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "volar";
        publisher = "Vue";
        version = "1.8.25";
        sha256 = "3RQ8dBy83QblARNMjy5RliVYSxEUdJA/3yyWcLK0wVQ=";
      }
    ];
  };
}
