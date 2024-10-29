{ config, pkgs, ... }:

{
  # This code snippet defines an `imports` attribute that filters and includes 
  # all `.nix` files from the current directory. It uses `builtins.readDir` to 
  # read the directory contents, `builtins.attrValues` to get the file paths, 
  # and `builtins.filter` along with `builtins.match` to select only the files 
  # with a `.nix` extension.
  imports = builtins.filter (path: builtins.match ".*\\.nix$" path != null) (builtins.attrValues (builtins.readDir (toString ./.)));

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  users.mutableUsers = false;
  users.users.maiko = {
    isNormalUser = true;
    extraGroups = [ "wheel" ] ++ (if config.virtualisation.virtualbox.guest.enable then ["vboxsf"] else []);
    hashedPassword = "$y$j9T$k81nRyY0poxbHmfDBwwCa0$XNHfeUWV1mnR3kqr7md2pVAenx/6yBOqPknp2vMxZ16";
  };
}
