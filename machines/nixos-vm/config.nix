_:

{
  imports = [
    ../company/config.nix
    ../../profiles/vm.nix
  ];

  networking.hostName = "nixos-vm";
}
