{
  description = "Maiko's NixOS Config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    code-insiders.url = "github:iosmanthus/code-insiders-flake";

    wechat-devtools.url = "github:MaikoTan/wechat-devtools";
  };
  outputs = { self, nixpkgs, nixos-generators, nixos-hardware, home-manager, sops-nix, ... }@inputs:
    let
      addMachineConfig = machine: {
        ${machine} = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = { allowUnfree = true; };
          };
          specialArgs = inputs;
          modules = [
            sops-nix.nixosModules.sops
            ./sops.nix
            ./machines/${machine}/config.nix
            ./modules/default.nix
            nixos-generators.nixosModules.all-formats
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

      # We need to filter out the "base" machine configuration because it is not a specific machine configuration
      # but rather a base configuration that other machine configurations can inherit from.
      # Additionally, we need to ensure that the machine is a directory and not a file.
      machineNames = builtins.attrNames (builtins.readDir (toString ./machines));
      filteredMachineNames = builtins.filter (machine: machine != "base" && (builtins.readFileType ./machines/${machine}) == "directory") machineNames;
      machineConfigs = map addMachineConfig filteredMachineNames;

    in
    {
      nixosConfigurations = (builtins.foldl' (a: b: a // b) { } machineConfigs);
    };
}
