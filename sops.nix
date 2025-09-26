{ config, pkgs, ... }:

{
  sops.age = {
    keyFile = "/var/lib/sops-nix/age/keys.txt";
  };

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
