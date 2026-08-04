{ config, lib, ... }:

let
  cfg = config.maiko.nix;
in

{
  imports = [
    ./gc.nix
    ./mirrors.nix
  ];

  options.maiko.nix.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Nix daemon configuration";
  };

  config = lib.mkIf cfg.enable {
    nix.settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "maiko-nixos-build.cachix.org-1:4EC5TVcsNL76xt7aqVoBpK0PoXPXuOF/kTLyjFyb8SM="
        "linyinfeng.cachix.org-1:sPYQXcNrnCf7Vr7T0YmjXz5dMZ7aOKG3EqLja0xr9MM="
      ];
    };

    nix.extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';
  };
}
