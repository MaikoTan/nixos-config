#! /usr/bin/env nix-shell
#! nix-shell -i fish -p dconf2nix

cd "$(dirname "$0")"

dconf dump / | dconf2nix > ./modules/home-manager/dconf.nix
