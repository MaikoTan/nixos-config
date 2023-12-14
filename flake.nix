{
  description = "Maiko's NixOS Config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, home-manager, ... }:
    let
      machines = ./machines/default.nix;
    in
    {
      nixosConfigurations = {
        nixos-vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./config.nix
            ./machines/nixos-vm/config.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.maiko = import ./home.nix;
            }
          ];
        };

        work-vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./config.nix
            ./machines/work-vm/config.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.maiko = import ./home.nix;
            }
          ];
        };
      };
    };
}
