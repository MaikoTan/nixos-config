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

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      shared = import ./flake/lib.nix { inherit inputs; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      flake = {
        nixosConfigurations = import ./flake/nixos.nix { inherit inputs; };
        homeConfigurations = import ./flake/home.nix { inherit inputs; };
      };

      perSystem =
        { system, ... }:
        let
          pkgs = shared.mkPkgs system;
        in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nixVersions.latest
              nixos-rebuild
              fish
              nixfmt
              cachix
              direnv
            ];
          };

          formatter = pkgs.nixfmt;

          checks = {
            statix = pkgs.runCommandLocal "statix-check"
              {
                src = ./.;
                nativeBuildInputs = [ inputs.statix.packages.${system}.statix ];
              }
              ''
                statix check ${./.} --config ${./.}/.statix.toml
                touch $out
              '';
          };
        };
    };
}
