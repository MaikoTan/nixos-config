{ config, lib, pkgs, ... }:

let
  cfg = config.maiko.packages;
in

{
  options.maiko.packages.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable system packages";
  };

  config = lib.mkIf cfg.enable {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      # System Utilities
      htop
      rsync
      curl
      wget
      lsof
      xprop
      # Text
      vim
    ];
  };
}