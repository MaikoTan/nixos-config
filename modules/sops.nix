{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.maiko.sops;
in

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.maiko.sops = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable sops-nix integration.";
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      age = {
        keyFile = "/var/lib/sops-nix/age/keys.txt";
      };

      defaultSopsFile = ../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
    };

    environment.systemPackages = with pkgs; [
      sops
      age
    ];
  };
}
