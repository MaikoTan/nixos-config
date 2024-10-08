# This file is used to configure the user environment for the VSCode extension.

{ config, ... }:

{
  # symlink `./snippets` to `~/.config/Code/User/snippets` or `~/.config/Code - Insiders/User/snippets` if using the Insiders edition
  home.file."vscode-snippets" = {
    source = ./snippets;
    target = "${config.home.homeDirectory}/.config/" +
      (if config.programs.vscode.isInsiders then "Code - Insiders" else "Code") +
      "/User/snippets";
  };
}
