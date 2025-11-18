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
      url = "github:Wassaaa/code-insiders-flake";
      # TODO: iosmanthus's version didn't update for a long time, switch back when
      # https://github.com/iosmanthus/code-insiders-flake/pull/2 is merged.
      # url = "github:iosmanthus/code-insiders-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wechat-devtools.url = "github:MaikoTan/wechat-devtools";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-generators,
      sops-nix,
      ...
    }@inputs:
    let
      generatorFormats =
        { config, ... }:
        {
          imports = [
            nixos-generators.nixosModules.all-formats
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
              nixpkgs.config.allowUnfree = true;
              nixpkgs.config.allowUnfreePredicate = _: true;
              nixpkgs.config.android_sdk.accept_license = true;
            }
            sops-nix.nixosModules.sops
            ./sops.nix
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
    };
}
