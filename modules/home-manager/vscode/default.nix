{ pkgs, code-insiders, ... }:

{
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    package = (code-insiders.packages."x86_64-linux".vscode-insider.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
    }));

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
        version = "2.0.8";
        sha256 = "3RQ8dBy83QblARNMjy5RliVYSxEUdJA/3yyWcLK0wVQ=";
      }
    ];
  };
}
