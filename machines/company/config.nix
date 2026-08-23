{
  inputs,
  ...
}:

{
  imports = [
    # Import common configuration from nixos
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.auto-cpufreq.nixosModules.default

    ./hardware.nix
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
