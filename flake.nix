{
  description = "Maiko's NixOS Config";

  inputs = {
    # NixOS channels
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Nix community projects
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";

    # Development tools
    code-insiders = {
      url = "github:iosmanthus/code-insiders-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wechat-devtools.url = "github:MaikoTan/wechat-devtools";

    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      overlays = [
        inputs.android-nixpkgs.overlays.default
      ];

      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        android_sdk.accept_license = true;
      };

      generatorFormats =
        { config, ... }:
        {
          imports = [
            inputs.nixos-generators.nixosModules.all-formats
          ];

          nixpkgs.hostPlatform = "x86_64-linux";

          # Customize the VM format
          formatConfigs.vm =
            { config, ... }:
            {
              virtualisation.memorySize = 4096;
              virtualisation.cores = 2;
            };
        };

      addMachineConfig = machine: {
        ${machine} = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            {
              nixpkgs.overlays = overlays;
              nixpkgs.config = config;
            }
            ./modules/sops.nix
            ./machines/${machine}/config.nix
            generatorFormats
          ];
        };
      };

      # We need to filter out the "base" machine configuration because it is not a specific machine configuration
      # but rather a base configuration that other machine configurations can inherit from.
      # Additionally, we need to ensure that the machine is a directory and not a file.
      machineNames = builtins.attrNames (builtins.readDir (toString ./machines));
      filteredMachineNames = builtins.filter (
        machine: machine != "base" && (builtins.readFileType ./machines/${machine}) == "directory"
      ) machineNames;
      machineConfigs = map addMachineConfig filteredMachineNames;

    in
    {
      nixosConfigurations = (builtins.foldl' (a: b: a // b) { } machineConfigs);

      homeConfigurations = {
        maiko = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = overlays;
            config = config;
          };
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./modules/home-manager
          ];
        };
      };

      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
          nixVersions.latest
          nixos-rebuild
          fish
          nixfmt
          cachix
        ];
      };
    };
}
