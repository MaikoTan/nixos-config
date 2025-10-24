{ pkgs, ... }:

{
  imports = [
    ./prompt.nix
    ./ssh-agent.nix
    ./yarn.nix
  ];

  programs.fish = {
    enable = true;

    functions = {
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };

    shellAliases = {
      ls = "${pkgs.eza}/bin/eza --color=auto";
      ll = "${pkgs.eza}/bin/eza --long --header --git --color=auto";
    };
  };
}
