{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.maiko.sunshine;

  # Sunshine needs to be told explicitly which capture backend to use.
  #
  # On Wayland the only backend KWin can serve is "kwin", which talks the
  # `zkde_screencast_unstable_v1` protocol directly to the compositor. The
  # upstream default is "x11", which cannot work on a Wayland session.
  #
  # Sunshine parses `name=value` style arguments on the command line and lets
  # them override the configuration file, so "capture=kwin" is passed as a
  # single argument.
  sunshineArgs = [
    (lib.getExe config.services.sunshine.package)
    "capture=kwin"
  ];

  # Re-enable a physical display that was switched off.
  #
  # Sunshine captures an existing output, so if the only attached monitor
  # has been powered down, KWin ends up with no output at all and Sunshine
  # aborts with "Unable to find display or encoder during startup".
  #
  # The script walks the DRM connectors and re-enables any that is connected
  # but disabled. A connector whose status is "disconnected" is skipped:
  # enabling a connector without a monitor attached does nothing, and
  # kscreen-doctor aborts on it.
  #
  # kscreen-doctor is a Qt application, so it needs the session environment
  # (WAYLAND_DISPLAY, XDG_RUNTIME_DIR, the session bus) to talk to KWin.
  # The user manager normally has all of these, but they are not inherited
  # by a service started outside the graphical session, so they are passed
  # in explicitly by the caller.
  wakeDisplayScript = pkgs.writeShellApplication {
    name = "sunshine-wake-display";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.kdePackages.libkscreen
      pkgs.systemd
    ];
    text = ''
      if [ -z "''${WAYLAND_DISPLAY:-}" ]; then
        echo "sunshine: no WAYLAND_DISPLAY in the environment; skipping output wake-up" >&2
        exit 0
      fi

      export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

      for delay in 0 1 2 4 8; do
        [ "$delay" = 0 ] || sleep "$delay"

        pending=0
        for connector_path in /sys/class/drm/card*-*; do
          [ -e "$connector_path/status" ] || continue
          connector="''${connector_path##*/}"
          status="$connector_path/status"
          [ "$(cat "$status" 2>/dev/null)" = "connected" ] || continue

          echo "sunshine: output $connector is disabled; re-enabling it" >&2
          kscreen-doctor "output.$connector.enable" >/dev/null 2>&1 || true
          pending=1
        done

        [ "$pending" = 0 ] && break
      done

      # Ask PowerDevil to wake the display as well. This covers the case where
      # KWin's connector list is stale and kscreen-doctor has nothing to
      # enable.
      if command -v busctl >/dev/null 2>&1; then
        busctl --user call org.kde.Solid.PowerManagement \
          /org/kde/Solid/PowerManagement org.kde.Solid.PowerManagement wakeup \
          >/dev/null 2>&1 || true
      fi
    '';
  };
in
{
  options.maiko.sunshine = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable Sunshine, a self-hosted game stream host for Moonlight. It
        streams the current desktop to a Moonlight client over the network.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Open Sunshine's ports in the NixOS firewall. Sunshine derives them from
        its base port (47989 by default): TCP 47984, 47989, 47990 and 48010,
        UDP 47998, 47999, 48000, 48002 and 48010.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      inherit (cfg) openFirewall;

      # NOTE: `services.sunshine.settings` is deliberately left empty. The
      # nixpkgs module renders any non-default setting into a read-only
      # `sunshine.conf` and passes it on the command line, which makes the
      # Web UI refuse to save any change. Leaving it empty keeps the Web UI
      # (http://localhost:47989) writable.
      #
      # `capSysAdmin` is left at its default of false. It would only add a
      # setcap wrapper, and the uinput approach below does not need it.
      #
      # `autoStart` is left at its default of true, which makes the unit
      # `wantedBy = graphical-session.target`. That target is active in a
      # Plasma session, so Sunshine starts with the desktop.
    };

    systemd.user.services.sunshine = {
      # The upstream unit starts the bare binary. We override ExecStart to
      # append the capture backend.
      #
      # This has to be a *string*, not a list: NixOS renders a list-valued
      # ExecStart as one `ExecStart=` line per element (see `attrsToSection`
      # in nixos/lib/systemd-lib.nix), and systemd only honours the last one
      # -- which would silently drop the binary path.
      serviceConfig.ExecStart = lib.mkForce (utils.escapeSystemdExecArgs sunshineArgs);

      # Make sure a physical display is powered on before Sunshine starts.
      # Without it, Sunshine aborts with "Unable to find display or encoder
      # during startup" when the only attached monitor is switched off.
      serviceConfig.ExecStartPre = lib.mkForce (utils.escapeSystemdExecArgs [ (lib.getExe wakeDisplayScript) ]);

      # KWin 6.8 dropped the screencast permission dialog entirely; there is
      # no `X-KDE-Wayland-Interfaces` handling left in KWin at all, and
      # `KWinDisplay::allowInterface()` only rejects sandboxed clients
      # (those running in systemd's app.slice). A normal user service runs
      # in user.slice and is therefore unconditionally allowed to bind
      # `zkde_screencast_unstable_v1` and `org_kde_kwin_fake_input`.
      # Sunshine still implements the old permission dance and writes a
      # temporary desktop file into ~/.local/share/applications on every
      # start, then sleeps three seconds waiting for KDE to pick it up. This
      # variable makes Sunshine skip that step.
      environment.KWIN_WAYLAND_NO_PERMISSION_CHECKS = "1";
    };

    # Keyboard and mouse injection goes through /dev/uinput (libevdev and
    # libvirtualhid). That device is owned by the "uinput" group, which
    # `services.sunshine` creates via `hardware.uinput.enable`.
    #
    # `lib.mkMerge` rather than `lib.mkAfter`: `extraGroups` is a plain list
    # option, so all definitions that share the highest priority are
    # concatenated. machines/company/services.nix also sets this option, and
    # both definitions have the same priority, so the groups end up merged
    # into one list instead of one replacing the other.
    users.users.maiko.extraGroups = lib.mkMerge [ [ "uinput" ] ];
  };
}
