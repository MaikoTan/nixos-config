{ config, lib, inputs, ... }:

let
  cfg = config.maiko.nix.gc;
in

{
  imports = [ inputs.angrr.nixosModules.angrr ];

  options.maiko.nix.gc.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Nix garbage collection and angrr";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };

      optimise = {
        automatic = true;
        dates = "weekly";
      };

      settings.auto-optimise-store = true;
    };

    services.angrr = {
      enable = true;
      settings = {
        temporary-root-policies = {
          direnv = {
            path-regex = "/\\.direnv/";
            period = "14d";
          };
          result = {
            path-regex = "/result[^/]*$";
            period = "3d";
          };
        };
        profile-policies = {
          system = {
            profile-paths = [ "/nix/var/nix/profiles/system" ];
            keep-since = "14d";
            keep-latest-n = 15;
            keep-booted-system = true;
            keep-current-system = true;
          };
          user = {
            enable = true;
            profile-paths = [
              "~/.local/state/nix/profiles/profile"
              "/nix/var/nix/profiles/per-user/maiko/profile"
              "/nix/var/nix/profiles/per-user/root/profile"
            ];
            keep-since = "7d";
            keep-latest-n = 5;
          };
        };
      };
    };
  };
}
