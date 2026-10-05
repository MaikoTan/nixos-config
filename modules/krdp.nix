# KDE Plasma built-in Remote Desktop (KRDP).
#
# Plasma's "Remote Desktop" settings page (KCM) is only a frontend for the
# `krdpserver` binary, which ships with an `app-org.kde.krdpserver.service`
# systemd *user* unit. The KCM never spawns the server itself: it asks systemd
# over D-Bus to start/stop that unit (see src/kcm/kcmkrdpserver.cpp, which
# calls StartUnit/StopUnit on
# /org/freedesktop/systemd1/unit/app_2dorg_2ekde_2ekrdpserver_2eservice).
#
# Two things must therefore line up, and neither happens by default from
# `services.desktopManager.plasma6.enable`, which only drops `krdp` into
# `environment.systemPackages`:
#
#   1. A unit named exactly `app-org.kde.krdpserver.service` must exist in the
#      *user* systemd instance. Without it the KCM's D-Bus calls fail, nothing
#      ever listens on the port, and every client (mstsc, FreeRDP, Remmina)
#      fails to connect.
#
#   2. The port has to be open in the NixOS firewall.
#
# On (1): krdp installs its unit to `$out/share/systemd/user/`, but NixOS's
# `generateUnits` (nixos/lib/systemd-lib.nix) only scans
# `$out/etc/systemd/user/*` and `$out/lib/systemd/user/*`. `share/` is not one
# of them, so adding krdp to `systemd.packages` links nothing and silently
# does nothing. We therefore declare the unit ourselves, reproducing upstream's
# contents. The unit name and ExecStart path have to stay byte-identical to
# what the KCM asks systemd for, or the KCM silently keeps failing.
#
# On the `[Install]` section: the KCM's "start at login" toggle calls
# `EnableUnitFiles`, and systemd refuses that on a static unit (one without
# `[Install]`). Without it, "start at login" silently never persists across
# Plasma logins. So we do emit upstream's
# `[Install] WantedBy=plasma-workspace.target` verbatim, via
# `systemd.user.units.<name>.text` (see the long comment at the declaration
# below for why we do not use the `wantedBy` option).

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.maiko.remote-desktop;

  inherit (pkgs) kdePackages;

  # NB: unlike `systemd.user.services` (which appends ".service" for you),
  # `systemd.user.units` keys are the full unit name as it appears on disk.
  # The suffix is appended below so it is written in exactly one place, and the
  # final name must be exactly "app-org.kde.krdpserver.service" -- that is what
  # the KCM asks systemd for over D-Bus.
  unitName = "app-org.kde.krdpserver";
in
{
  options.maiko.remote-desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable KDE Plasma's built-in Remote Desktop server (KRDP), which serves
        the current Plasma session over RDP so it can be reached from a Windows
        Remote Desktop (mstsc) client. Requires a Wayland Plasma session.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3389;
      description = ''
        TCP port to open in the firewall. The port the server actually binds is
        the one configured in the Plasma "Remote Desktop" settings page, which
        also defaults to 3389.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open the RDP port in the NixOS firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.desktopManager.plasma6.enable;
        message = "maiko.remote-desktop.enable requires services.desktopManager.plasma6.enable (KRDP is a Plasma component).";
      }
      {
        assertion = config.security.pam.services.kde.kwallet.enable;
        message = "KRDP stores RDP passwords in KWallet, which requires kwallet-pam (Plasma normally enables this for you).";
      }
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    # Deliberately NOT started or enabled here. The Plasma KCM owns the on/off
    # state (it calls StartUnit/StopUnit over D-Bus, and EnableUnitFiles when
    # you tick "start at login"). Force-enabling it from Nix would both fight
    # the KCM and expose an RDP server the user never asked to turn on.
    #
    # The `[Install]` section below is *metadata only*: systemd needs it for the
    # KCM's `EnableUnitFiles` call to succeed at all, and it is the standard way
    # to say "this unit is eligible to be enabled by the user". It does NOT
    # enable the unit by itself.
    #
    # We deliberately declare this as a raw unit under `systemd.user.units`
    # rather than via `systemd.user.services.<name>.wantedBy`. NixOS's
    # `generateUnits` (nixos/lib/systemd-lib.nix) turns `wantedBy` into BOTH an
    # `[Install]` section AND a real `plasma-workspace.target.wants/
    # app-org.kde.krdpserver.service` symlink in /etc/systemd/user, which would
    # force-start an RDP server listening on 0.0.0.0:3389 on every Plasma
    # login -- exactly the default this module refuses to impose. Passing
    # `text` with no `wantedBy` emits the unit file verbatim and creates no
    # `.wants` link, so enabling stays a user decision made through the KCM.
    systemd.user.units."${unitName}.service" = {
      text = ''
        [Unit]
        Description=KRDP Server
        Documentation=https://invent.kde.org/plasma/krdp
        After=plasma-xdg-desktop-portal-kde.service
        After=plasma-core.target

        [Service]
        Type=exec
        ExecStart=${lib.getBin kdePackages.krdp}/bin/krdpserver
        Restart=on-abnormal

        [Install]
        WantedBy=plasma-workspace.target
      '';
    };
  };
}
