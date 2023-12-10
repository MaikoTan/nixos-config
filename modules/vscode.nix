{
  vscode-utils,
  vscode-extensions,
  vscode-with-extensions,
  ...
}: vscode-with-extensions.override {
  vscodeExtensions = with vscode-extensions; [
    WakaTime.vscode-wakatime
    rust-lang.rust-analyzer
    jnoortheen.nix-ide
    eamodio.gitlens
    github.copilot
    bbenoist.nix
    mkhl.direnv
    golang.go
  ] ++ vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "volar";
      publisher = "Vue";
      version = "1.8.25";
      sha256 = "3RQ8dBy83QblARNMjy5RliVYSxEUdJA/3yyWcLK0wVQ=";
    }
  ];
}
