{ nixos-hardware, ... }:

{
  imports =
    [
      # Import common configuration from nixos
      nixos-hardware.nixosModules.common-cpu-intel
      ../base/desktop.nix
      ./hardware.nix
    ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  networking.hostName = "company";

  networking = {
    interfaces.enp2s0 = {
      ipv4.addresses = [{
        address = "192.168.30.80";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.30.254";
      interface = "enp2s0";
    };
  };

  nix.use-china-mirrors = true;

  # TODO: fix zerotier build issue
  # Automatically join the ZeroTier network.
  # services.zerotierone = {
  #   enable = true;
  #   joinNetworks = [
  #     "35c192ce9bf3258b"
  #   ];
  # };
}
