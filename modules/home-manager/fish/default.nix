{ pkgs, ... }:

{
  imports = [
    ./prompt.nix
  ];

  systemPackages = with pkgs; [ eza ];

  programs.fish = {
    enable = true;

    functions = {
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };

    shellAliases = {
      ls = "eza";
      ll = "eza -la";
    };
  };

  users.defaultUserShell = pkgs.fish;
}
