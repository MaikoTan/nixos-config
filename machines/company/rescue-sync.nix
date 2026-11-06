# Keep the standalone rescue system (../machines/rescue) in sync with the
# main configuration on the spare rescue partition (nvme0n1p2, label=rescue).
#
# Two triggers, because `nh os boot` and `nh os switch` go down different
# paths in switch-to-configuration-ng:
#   * boot   -- installs the bootloader and exits before activation, so the
#              hook lives in boot.loader.grub.extraInstallCommands (the
#              installer script is run by both boot and switch).
#   * switch -- runs the same hook, then reboots into a generation whose
#              systemd oneshot (wantedBy) covers the case where the partition
#              was missing when the generation was built.
# The hook blocks until the sync finishes; the service's fast path makes it a
# no-op when the rescue generation is already current.
{
  config,
  inputs,
  pkgs,
  ...
}:

let
  rescueToplevel = inputs.self.nixosConfigurations.rescue.config.system.build.toplevel;

  syncScript = pkgs.writeShellScript "rescue-sync" ''
    set -euo pipefail

    rescueDev=/dev/disk/by-label/rescue
    espDev=/dev/disk/by-label/boot
    mnt=/mnt/rescue-sync
    toplevel=${rescueToplevel}
    installer=${config.system.build.nixos-install}/bin/nixos-install

    if [ ! -e "$rescueDev" ]; then
      echo "rescue-sync: no rescue partition ($rescueDev), skipping"
      exit 0
    fi

    mkdir -p "$mnt"
    # Leave it alone when something else mounted it (e.g. manual repair).
    if mountpoint -q "$mnt"; then
      echo "rescue-sync: $mnt already mounted, skipping"
      exit 0
    fi
    trap 'umount -R "$mnt" 2>/dev/null || true' EXIT

    # Fast path: the rescue partition already runs this exact generation.
    # nixos-install writes the system profile as a symlink to the logical
    # /nix/store path, so readlink resolves to the same path as $toplevel.
    mount -o ro "$rescueDev" "$mnt"
    installed="$(readlink -f "$mnt/nix/var/nix/profiles/system" 2>/dev/null || true)"
    if [ "$installed" = "$toplevel" ]; then
      echo "rescue-sync: already at $toplevel"
      exit 0
    fi

    # The ESP must be visible under the rescue root for GRUB to install its
    # own /EFI/rescue/grubx64.efi entry.
    mount -o remount,rw "$mnt"
    mkdir -p "$mnt/boot/efi"
    mount "$espDev" "$mnt/boot/efi"

    echo "rescue-sync: installing $toplevel onto $rescueDev"
    "$installer" \
      --root "$mnt" \
      --system "$toplevel" \
      --no-channel-copy \
      --no-root-passwd

    # The 7.6G partition must not fill with old generations when the rescue
    # system is never booted (its own nix.gc only runs once it is booted).
    # Delete the old system generations explicitly, then collect paths that
    # became unreachable. `--store "$mnt"` is a chroot store: its profile
    # symlinks are registered as gcroots, so the current generation survives.
    # Best effort: a GC hiccup must not fail the sync.
    (
      ${config.nix.package}/bin/nix-env --store "$mnt" \
        -p "$mnt/nix/var/nix/profiles/system" \
        --delete-generations old || true
      ${config.nix.package}/bin/nix-store --store "$mnt" --gc || true
    )

    echo "rescue-sync: done"
  '';
in
{
  systemd.services.rescue-sync = {
    description = "Sync the rescue system to the rescue partition";
    after = [
      "local-fs.target"
      "nix-daemon.service"
    ];
    wants = [ "nix-daemon.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutStartSec = "30min";
      # A failure must not stop the boot; the previous rescue stays bootable.
      Restart = "on-failure";
      RestartSec = "1min";
    };
    unitConfig = {
      StartLimitIntervalSec = "10min";
      StartLimitBurst = 3;
    };
    serviceConfig.ExecStart = toString syncScript;
  };

  # `nh os boot` exits right after installing the bootloader, so this is the
  # only hook that reliably runs for both boot and switch. Failure is
  # non-fatal: the main system must still become bootable.
  boot.loader.grub.extraInstallCommands = ''
    ${syncScript} || echo "rescue-sync failed; see journalctl -u rescue-sync" >&2
  '';

  # `switch` cannot rely on activationScripts alone: it also runs the GRUB
  # installer above, which is the only hook shared with `nh os boot`.
}
