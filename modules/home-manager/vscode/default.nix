{ pkgs, ... }:

{
  imports = [
    ./insiders.nix
  ];

  # Install packages required by vscode extensions
  home.packages = with pkgs; [
    nil
  ];
}
