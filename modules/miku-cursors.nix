{ config, lib, pkgs, ... }:

let
  cfg = config.maiko.miku-cursors;
  version = "1.2.6";
  miku-cursors = pkgs.stdenvNoCC.mkDerivation {
    name = "miku-cursors";
    inherit version;
    src = pkgs.fetchFromGitHub {
      owner = "supermariofps";
      repo = "hatsune-miku-windows-linux-cursors";
      rev = version;
      hash = "sha256-OQjjOc9VnxJ7tWNmpHIMzNWX6WsavAOkgPwK1XAMwtE=";
    };
    buildPhase = "
      mkdir -p $out/share/icons/miku-cursor
      cp -r $src/miku-cursor-linux/* $out/share/icons/miku-cursor/
    ";
  };
in

{
  options.maiko.miku-cursors.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Hatsune Miku cursors";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ miku-cursors ];
  };
}
