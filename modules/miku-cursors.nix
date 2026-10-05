{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.maiko.miku-cursors;
in

{
  options.maiko.miku-cursors.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Hatsune Miku cursors";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.miku-cursors ];
  };
}
