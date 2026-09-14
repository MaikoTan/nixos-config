# Hand-written wrapper for auto-generated desktop configs.
#
# dconf.nix (dconf2nix) and plasma-rc.nix (plasma-manager) are auto-generated
# and must stay untouched so they can be re-generated any time. This module
# pulls them in only when maiko.hm.desktop is enabled (see machine.nix).
{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.maiko.hm.desktop ((import ./dconf.nix { inherit lib; }) // (import ./plasma-rc.nix));
}
