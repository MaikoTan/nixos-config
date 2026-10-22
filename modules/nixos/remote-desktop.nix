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
# The unit additionally passes `--plasma`, which is what makes the server
# usable at all. Without it krdpserver talks to the XDG Desktop Portal
# (`xdg-desktop-portal-kde`) to get a RemoteDesktop session. On a Plasma
# session that portal cannot provide one, so it answers with an error and
# the user gets the dialog "The application KRdp tried to start a remote
# desktop session but remote desktop is not available on this system."
# (the server log shows "Failed to register with host portal"). With
# `--plasma` krdpserver uses Plasma's own protocols instead: it binds
# `zkde_screencast_unstable_v1` for screen capture and
# `org_kde_kwin_fake_input` for input injection, both of which KWin serves to
# non-sandboxed local clients.
#
# KRDP authentication: when `--username` is NOT passed (our case), the server
# reads `SystemUserEnabled` from ~/.config/krdpserverrc (default false). If
# true, it uses PAM with the standard "login" service (NOT "krdpserver" --
# that string is the KDE screencast authorization token, see
# PlasmaScreencastV1Session.cpp). PAM mode uses TLS security layer (no NLA).
# The RDP client must send username = local login name (maiko) and the system
# login password. pam_unix(login) runs as the user (euid=1000) and needs to
# read /etc/shadow (0640 root:shadow). NixOS's unix_chkpwd helper lacks the
# setuid bit, so pam_unix cannot delegate to it; the fix is adding the user
# to the "shadow" group so pam_unix can read /etc/shadow directly.
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

  # A script that creates the TLS certificate and key for the RDP server on
  # first start, inside the user's own data directory.
  #
  # The target directory is passed as the first argument, so that the script
  # and the krdpserver command line below always agree on the location.
  #
  # Why not derive the certificate in the Nix store?
  #
  #   1. The Nix store normalises every file to mode 0444, so a private key
  #      stored there is world-readable to every local user. Deriving it at
  #      build time would therefore publish the key. The key has to be
  #      created at runtime, in a directory only the user can read.
  #
  #   2. A build-time certificate would be baked into the store and shared
  #      between machines and between rebuilds, i.e. rotating it would
  #      require a rebuild. Generating it on first start keeps the key
  #      local and lets it be rotated by deleting the file.
  #
  # Why not let the Plasma KCM generate it?
  #
  # The KCM can do that, but it runs `openssl req ... -days 1`, i.e. the
  # certificate is valid for exactly one day, and it refuses to regenerate
  # while the KConfig already holds a `Certificate=` value. An expired
  # certificate would then stay expired forever, and the KCM performs no
  # expiry check at all, so the server happily starts with a dead
  # certificate and every client fails with a TLS error.
  #
  # The certificate is passed on the command line, which takes precedence
  # over the KConfig values (see `parserValueWithDefault` in server/main.cpp),
  # so this script's output always wins over whatever the KCM has stored in
  # ~/.config/krdpserverrc.
  certificateScript = pkgs.writeShellApplication {
    name = "krdp-generate-certificate";
    runtimeInputs = [
      pkgs.openssl
      pkgs.coreutils
    ];
    text = ''
      cert_dir="$1"
      cert="$cert_dir/krdp.crt"
      key="$cert_dir/krdp.key"

      # Already generated and still valid: keep it, so the certificate does
      # not change on every service restart (which would invalidate clients
      # that pinned the old one).
      if [ -s "$cert" ] && [ -s "$key" ]; then
        if openssl x509 -in "$cert" -noout -checkend 86400 >/dev/null 2>&1; then
          exit 0
        fi
      fi

      mkdir -p "$cert_dir"
      chmod 700 "$cert_dir"

      # Regenerate from scratch: the old key must be replaced together with
      # the certificate.
      rm -f "$cert" "$key"

      # The subject alternative names cover the common ways a client reaches
      # this machine. FreeRDP warns about a name mismatch between the
      # certificate and the host the client connected to, and mstsc refuses
      # an untrusted certificate outright.
      openssl req -nodes -new -x509 \
        -keyout "$key" \
        -out "$cert" \
        -days 3650 \
        -subj "/CN=${config.networking.hostName}" \
        -addext "subjectAltName=DNS:${config.networking.hostName},DNS:localhost,IP:127.0.0.1" \
        -batch

      chmod 600 "$key"
      chmod 644 "$cert"
    '';
  };
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
        assertion = config.security.pam.services.login.kwallet.enable;
        message = "KRDP authenticates against the 'login' PAM service, whose kwallet module must be enabled so the RDP password can be read from KWallet.";
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
        ExecStartPre=${lib.getExe certificateScript} %h/.local/share/krdpserver
        ExecStart=${lib.getBin kdePackages.krdp}/bin/krdpserver --plasma --certificate %h/.local/share/krdpserver/krdp.crt --certificate-key %h/.local/share/krdpserver/krdp.key
        Restart=on-abnormal

        [Install]
        WantedBy=plasma-workspace.target
      '';
    };
  };
}
