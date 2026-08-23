{
  description = "Maiko's NixOS Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.flake-parts.follows = "flake-parts";
    };

    angrr = {
      url = "github:linyinfeng/angrr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    code-insiders = {
      url = "github:iosmanthus/code-insiders-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wechat-devtools = {
      url = "github:MaikoTan/wechat-devtools";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
      };
    };

    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    statix = {
      url = "github:oppiliappan/statix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = { pkgs, ... }: {
        formatter = pkgs.nixfmt;

        checks.statix =
          pkgs.runCommandLocal "statix-check"
            {
              src = ./.;
              nativeBuildInputs = [ pkgs.statix ];
            }
            ''
              statix check ${./.} --config ${./.}/.statix.toml
              touch $out
            '';
      };

      flake =
        let
          rime-patched-pkgs =
            let
              pkgs = import nixpkgs { system = "x86_64-linux"; };
            in
            import
              (pkgs.applyPatches {
                name = "rime-patched";
                src = nixpkgs;
                patches = [
                  (pkgs.fetchpatch {
                    url = "https://github.com/NixOS/nixpkgs/pull/501829.patch";
                    hash = "sha256-Ng518PqrRBzek7JxaIjAY0GV00ldZY6DKeM+Go8RvF8=";
                  })
                ];
              })
              {
                system = "x86_64-linux";
                config = {
                  allowUnfree = true;
                  allowUnfreePredicate = _: true;
                };
              };

          overlays = [
            inputs.android-nixpkgs.overlays.default
            inputs.angrr.overlays.default
            inputs.statix.overlays.default
            (_: super: {
              inherit (rime-patched-pkgs) rime-flypy;
              rime-tlpa = super.callPackage ./rime-tlpa.nix {
                inherit (rime-patched-pkgs) rime-prelude;
              };
              freedownloadmanager = super.callPackage ./freedownloadmanager.nix { };
            })
          ];

          nixpkgsConfig = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
            android_sdk.accept_license = true;
          };

          nixosModule = {
            nixpkgs.overlays = overlays;
            nixpkgs.config = nixpkgsConfig;
          };

        in
        {
          devShells.x86_64-linux.default =
            let
              shellPkgs = import nixpkgs {
                system = "x86_64-linux";
                config = {
                  allowUnfree = true;
                };
              };
            in
            shellPkgs.mkShell {
              buildInputs = with shellPkgs; [
                nixVersions.latest
                nixos-rebuild
                fish
                nixfmt
                cachix
                direnv
              ];
            };

          nixosConfigurations = {
            company = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = [
                nixosModule
                ./machines/company/config.nix
              ];
            };

            wsl = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = [
                nixosModule
                ./machines/wsl/config.nix
              ];
            };

            nixos-vm = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = [
                nixosModule
                # qemu-vm 模块在 machines/nixos-vm/config.nix 中导入，
                # 提供 system.build.vm（nixos-rebuild build-vm）与虚拟化选项。
                ./machines/nixos-vm/config.nix
              ];
            };
          };

          homeConfigurations.maiko = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              system = "x86_64-linux";
              config = nixpkgsConfig;
              inherit overlays;
            };
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./modules/home-manager
              inputs.plasma-manager.homeModules.plasma-manager
            ];
          };
        };
    };
}
