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

    angrr = {
      url = "github:linyinfeng/angrr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    statix = {
      url = "github:oppiliappan/statix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      overlays = [
        inputs.android-nixpkgs.overlays.default
        inputs.angrr.overlays.default
        inputs.statix.overlays.default
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
    {
      nixosConfigurations = builtins.foldl' (
        configs: host:
        configs
        // {
          ${host.hostname} = nixpkgs.lib.nixosSystem {
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
              ./machines/${host.hostname}/config.nix
            ]
            ++ host.modules;
          };
        }
      ) { } hosts;

      homeConfigurations = {
        maiko = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            inherit overlays;
            inherit config;
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
          direnv
        ];
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;

      checks.x86_64-linux = {
        statix =
          nixpkgs.legacyPackages.x86_64-linux.runCommandLocal "statix-check"
            {
              src = ./.;
              nativeBuildInputs = [ inputs.statix.packages.x86_64-linux.statix ];
            }
            ''
              statix check ${./.} --config ${./.}/.statix.toml
              touch $out
            '';
      };
    };
}
