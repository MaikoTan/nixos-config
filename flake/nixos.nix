{ inputs }:
let
  shared = import ./lib.nix { inherit inputs; };

  generatorFormats =
    { ... }:
    {
      imports = [
        inputs.nixos-generators.nixosModules.all-formats
      ];

      nixpkgs.hostPlatform = "x86_64-linux";

      formatConfigs.vm =
        { ... }:
        {
          virtualisation.memorySize = 4096;
          virtualisation.cores = 2;
        };
    };

  hosts = [
    {
      hostname = "company";
      modules = [ ];
    }
    {
      hostname = "wsl";
      modules = [ ];
    }
    {
      hostname = "nixos-vm";
      modules = [ generatorFormats ];
    }
  ];
in
builtins.listToAttrs (
  map (host: {
    name = host.hostname;
    value = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        {
          nixpkgs.overlays = shared.overlays;
          nixpkgs.config = shared.nixpkgsConfig;
        }
        ./../modules/sops.nix
        ./../machines/${host.hostname}/config.nix
      ] ++ host.modules;
    };
  }) hosts
)
