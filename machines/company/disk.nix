# Disk layout for the company machine, managed by disko.
#
# This mirrors the existing on-disk layout (ext4 root labelled "nixos",
# ESP mounted at /boot/efi, a second 1TB drive as ext4 "Data"), with one
# deliberate change: the old 7.6G Windows RECOVERY partition is not
# recreated; its space goes to the root partition.
#
# The devices are pinned by their hardware serials under /dev/disk/by-id
# so that adding or reordering disks cannot make the layout apply to the
# wrong drive.
#
# Inspect with `nix run github:nix-community/disko -- --dry-run ./machines/company/disk.nix`
# (it prints the path of the generated script; review the partition/mkfs/
# mount commands in it before going further). To actually format and mount
# the disks, run the same command with `--mode destroy,format,mount`:
# sgdisk --clear wipes both partition tables, so this is strictly a
# reinstall-time operation. During a NixOS install, prefer disko-install,
# which formats the disks and runs the NixOS installer in one go:
#   sudo nix run github:nix-community/disko -- \
#     --flake /path/to/nixos-config#company \
#     --disk nvme /dev/disk/by-id/nvme-ZHITAI_PC005_Active_512GB_ZTA1512JA212660459 \
#     --disk data /dev/disk/by-id/ata-ST1000DM010-2EP102_Z9AS7F2C
{
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-ZHITAI_PC005_Active_512GB_ZTA1512JA212660459";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              # The installed ESP is 94M, which is enough for GRUB's single
              # removable-binary install, but 512M leaves room for kernels
              # or a future bootloader switch without repartitioning.
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                # Keep the same filesystem labels as the manual install so
                # that either by-label or disko's by-partlabel references
                # keep working. mkfs.vfat takes the label via -n.
                extraArgs = [
                  "-n"
                  "boot"
                ];
                # Must match hardware.nix: GRUB is installed with
                # efiInstallAsRemovable and expects the ESP at /boot/efi.
                mountpoint = "/boot/efi";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                # Label must match / by-label reference in hardware.nix.
                extraArgs = [
                  "-L"
                  "nixos"
                ];
                mountpoint = "/";
              };
            };
          };
        };
      };

      data = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST1000DM010-2EP102_Z9AS7F2C";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                # Label must match the /mnt/data by-label reference in
                # hardware.nix.
                extraArgs = [
                  "-L"
                  "Data"
                ];
                mountpoint = "/mnt/data";
              };
            };
          };
        };
      };
    };
  };
}
