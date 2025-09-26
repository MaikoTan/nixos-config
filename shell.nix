{
  pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") { },
}:
pkgs.mkShell {
  packages = with pkgs; [
    nixVersions.latest
    nixos-rebuild
    fish
    nixfmt
    cachix
  ];
  shellHook = ''
    export EDITOR=vim
    export VISUAL=vim

    cachix use maiko-nixos-build || true
  '';
}
