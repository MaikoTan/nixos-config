# Machine-specific toggles for home-manager.
# Set these in per-machine home configurations (e.g. machines/<host>/home.nix).
{
  lib,
  ...
}:

{
  options.maiko.hm = {
    desktop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable desktop (GUI) configuration: Plasma, GNOME dconf, IME, GUI packages.
        Used on full desktop machines (e.g. company). Disabled on WSL.
      '';
    };

    android = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Android SDK and Android Studio (heavy, desktop only).";
    };
  };
}
