{
  inputs,
  ...
}:

{
  imports = [
    # Import common configuration from nixos
    inputs.nixos-hardware.nixosModules.common-cpu-intel

    # Disk layout, see ./disk.nix
    inputs.disko.nixosModules.default
    ./disk.nix

    ./hardware.nix
    # Keep ../rescue in sync with this flake on every nh os boot/switch.
    ./rescue-sync.nix
    # company-specific capability modules
    ./network.nix
    ./services.nix
    ./github-runners.nix
    ../../profiles/desktop.nix
  ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # TODO: Fix GTK4 apps rendering issue with Intel UHD 630
  environment.sessionVariables = {
    GSK_RENDERER = "gl";
  };
}
