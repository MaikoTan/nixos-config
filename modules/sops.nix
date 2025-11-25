{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.maiko.sops or { enable = true; };

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

  config.sops = lib.mkIf cfg.enable {
    age = {
      keyFile = "/var/lib/sops-nix/age/keys.txt";
    };

    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };

  config.environment.systemPackages = lib.mkIf cfg.enable (
    with pkgs;
    [
      sops
      age
    ]
  );
}
