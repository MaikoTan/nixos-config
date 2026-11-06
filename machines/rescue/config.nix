# Rescue system installed into the spare 7.6G NVMe partition (nvme0n1p2).
# Purpose: when the main system (company) is unbootable, boot this from the
# firmware menu (or via GRUB chainload) and use it to mount, inspect and repair
# the main root partition -- including `nixos-enter` into a broken generation.
#
# It deliberately carries no sops secrets, no home-manager, and no overlays:
# it must be trivially rebuildable from this repo alone, even when the main
# system is dead.
{ pkgs, ... }:

{
  imports = [
    ../../modules/nixos/nix
    ../../modules/nixos/nh.nix
  ];

  networking.hostName = "rescue";

  # Same substituters/mirrors as the main system, so repairing the company
  # configuration can pull closed-over paths from cachix instead of building.
  maiko = {
    nix = {
      enable = true;
      useChinaMirrors = true;
    };
    nh.enable = true;
  };

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  console.useXkbConfig = true;

  boot = {
    loader.efi.efiSysMountPoint = "/boot/efi";

    loader.grub = {
      enable = true;
      efiSupport = true;
      # Install under its own EFI directory instead of the firmware default
      # so it cannot clobber the main system's boot entry or its removable
      # fallback. The main GRUB chainloads /EFI/rescue/grubx64.efi.
      efiInstallAsRemovable = false;
      # Leave devices empty: setting device = "nodev" would auto-append a
      # default mirroredBoot next to the explicit one below.
      # canTouchEfiVariables stays off (the default), so grub-install passes
      # --no-nvram and the firmware boot order is never touched.
      mirroredBoots = [
        {
          path = "/boot";
          devices = [ "nodev" ];
          # Renames the installed EFI binary from the default "NixOS" to
          # "rescue", i.e. /EFI/rescue/grubx64.efi on the ESP.
          efiBootloaderId = "rescue";
          efiSysMountPoint = "/boot/efi";
        }
      ];
      # grub.cfg is written to the ESP (p1), but the kernels it boots live on
      # the rescue root (p2); the generated menu locates the root by
      # LABEL=rescue, so no extra GRUB plumbing is needed here.
    };

    # Rescue only: never mount other disks automatically. Mounting the
    # (possibly broken) main root partition here could hang the rescue boot.
    initrd.supportedFilesystems = [
      "ext4"
      "vfat"
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/rescue";
    fsType = "ext4";
  };

  # No swap: this system runs from a 7.6G partition and must not touch zram.
  zramSwap.enable = false;

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  # Remote rescue when the machine is physically elsewhere.
  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    # Repo + network: clone the config, inspect, rebuild.
    git
    curl
    wget
    jq
    # Filesystems that may turn up on the company machine.
    e2fsprogs
    dosfstools
    ntfs3g
    btrfs-progs
    xfsprogs
    # Rescue-specific tools.
    disko
    sops
    age
    parted
    gptfdisk
    smartmontools
    # Comfort: a terminal multiplexer keeps long repairs running.
    tmux
  ];

  # The rescue root is a 7.6G partition; keep old generations from filling it.
  # angrr-style GC is configured in the shared nix module; here only the
  # automatic systemd timer needs no extra setup because nix.gc comes from
  # nixos itself, not from maiko.nix.gc.
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";

  users.users.root.initialHashedPassword = "";

  system.stateVersion = "25.11";
}
