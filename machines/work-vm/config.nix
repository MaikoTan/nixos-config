{ ... }:

{
  imports = [
    ../base/vbox-vm.nix
    ./hardware.nix
  ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  networking.hostName = "work-vm";
}
