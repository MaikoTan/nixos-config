# dsh systemd user service module
# Provides a user service for running DeepSeek Agent CLI (dsh) in the background.
# The web profile requires external bundles that are installed on first start via `dsh plugin --profile web install`.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.dsh;
in
{
  options.services.dsh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable the dsh (DeepSeek Harness) user service.
        Runs the web profile in the background.
      '';
    };

    profile = lib.mkOption {
      type = lib.types.str;
      default = "web";
      description = "The dsh profile to run (e.g., 'web', 'tui', 'headless').";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra arguments passed to the dsh command.";
    };

    serviceEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Additional environment variables for the service.";
    };

    # Auto-install missing profile bundles on service start
    autoInstallBundles = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        If true, run `dsh plugin --profile <profile> install` before starting the service
        to install any missing external bundles (dsh-tools, dsh-preview, etc.).
        Requires pnpm to be available in PATH.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Ensure pnpm is available for bundle installation
    home.packages = with pkgs; [ (import <nixpkgs> { }).pnpm ];

    systemd.user.services.dsh = {
      description = "DeepSeek Harness (dsh) - ${cfg.profile} profile";
      after = [ "network.target" ];
      wants = [ "network.target" ];

      # Pre-start: install missing profile bundles if needed
      serviceConfig = {
        Type = "simple";
        ExecStartPre = lib.mkIf cfg.autoInstallBundles ''
          ${pkgs.dsh}/bin/dsh plugin --profile ${cfg.profile} install
        '';
        ExecStart = "${pkgs.dsh}/bin/dsh ${cfg.profile} ${lib.concatStringsSep " " cfg.extraArgs}";
        Restart = "on-failure";
        RestartSec = "10s";
        Environment = lib.mapAttrsToList (k: v: "${k}=${v}") cfg.serviceEnvironment;
      };

      wantedBy = [ "default.target" ];
    };
  };
}
