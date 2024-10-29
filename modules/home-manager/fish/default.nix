{ pkgs, ... }:

{
  imports = [
    ./prompt.nix
  ];

  programs.fish = {
    enable = true;

    functions = {
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };
  };

  users.defaultUserShell = pkgs.fish;
}
