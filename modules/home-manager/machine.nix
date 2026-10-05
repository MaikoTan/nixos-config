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

    # Toggle groups that were previously always-on. Defaults preserve current
    # behavior (everything enabled); they exist so per-machine configs can opt
    # out of whole feature sets without editing the shared modules.
    git = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable git, gh, and gh-dash configuration.";
    };

    extras = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable direnv, zoxide, jq, and fastfetch programs.";
    };

    services = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable background services (gpg-agent, remmina).";
    };
  };
}
