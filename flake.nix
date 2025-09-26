{
  description = "Maiko's NixOS Config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-2411.url = "github:NixOS/nixpkgs/nixos-24.11";

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
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-2411,
      nixos-generators,
      nixos-hardware,
      home-manager,
      sops-nix,
      ...
    }@inputs:
    let
      oldPkgs = import nixpkgs-2411 {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
        };
        # Override GNOME packages with older versions by using nixpkgs overlays
        overlays = [
          (final: prev: {
            gnome = oldPkgs.gnome;
            dconf = oldPkgs.dconf;
            gnomeExtensions = oldPkgs.gnomeExtensions;
            # other packages that depend on gnome
            nautilus = oldPkgs.nautilus;
            baobab = oldPkgs.baobab;
            decibels = oldPkgs.decibels;
            epic5 = oldPkgs.epic5;
            gdm = oldPkgs.gdm;
            grilo-plugins = oldPkgs.grilo-plugins;
            loupe = oldPkgs.loupe;
            malcontent = oldPkgs.malcontent;
            orca = oldPkgs.orca;
            papers = oldPkgs.papers;
            rygel = oldPkgs.rygel;
            showtime = oldPkgs.showtime;
            simple-scan = oldPkgs.simple-scan;
            snapshot = oldPkgs.snapshot;
            sushi = oldPkgs.sushi;
            tecla = oldPkgs.tecla;
            yelp = oldPkgs.yelp;
          })
          # programmatically replace all packages starting with `gnome-` or `gvfs-` with the version from oldPkgs
          (
            final: prev:
            let
              shouldReplaceNames = builtins.filter (
                name: prev.lib.strings.hasPrefix "gnome-" name || prev.lib.strings.hasPrefix "gvfs-" name
              ) (builtins.attrNames prev);
            in
            builtins.listToAttrs (
              map (name: {
                name = name;
                value = oldPkgs.${name};
              }) shouldReplaceNames
            )
          )
        ];
      };
      patchedSrc = pkgs.applyPatches {
        name = "nixpkgs-rust-patched";
        src = nixpkgs;
        patches = [
          (pkgs.fetchpatch {
            url = "https://github.com/NixOS/nixpkgs/pull/438535.patch";
            sha256 = "sha256-rbqKY6aLB+T6mJvWoTJure08T2XrGH8QP1CKQWwop/M=";
          })
        ];
      };
      patchedPkgs = import patchedSrc {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
        };
      };

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
          inherit pkgs;
          specialArgs = inputs // {
            inherit patchedPkgs;
          };
          modules = [
            sops-nix.nixosModules.sops
            ./sops.nix
            ./machines/${machine}/config.nix
            ./modules/default.nix
            generatorFormats
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
      filteredMachineNames = builtins.filter (
        machine: machine != "base" && (builtins.readFileType ./machines/${machine}) == "directory"
      ) machineNames;
      machineConfigs = map addMachineConfig filteredMachineNames;

    in
    {
      nixosConfigurations = (builtins.foldl' (a: b: a // b) { } machineConfigs);
    };
}
