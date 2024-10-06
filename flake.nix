{
  description = "Maiko's NixOS Config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    code-insiders.url = "github:iosmanthus/code-insiders-flake";

    rime-japanese.url = "github:MaikoTan/rime-japanese/nix";
  };
  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      addMachineConfig = machine: {
        ${machine} = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules/default.nix
            ./machines/${machine}/config.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = inputs;
              home-manager.users.maiko = import ./modules/home-manager;
            }
          ];
        };
      };

      machineConfigs = map addMachineConfig (builtins.filter (machine: machine != "base") (builtins.attrNames (builtins.readDir (toString ./machines))));

    in
    {
      nixosConfigurations = (builtins.foldl' (a: b: a // b) { } machineConfigs);
    };
}
