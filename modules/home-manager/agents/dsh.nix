# dsh systemd user service module
# Provides a user service for running DeepSeek Agent CLI (dsh) in the background.
# The web profile requires external bundles that are installed on first start via `dsh plugin --profile web install`.
{ config, lib, pkgs, ... }:

let
  cfg = config.services.dsh;
  cfgPrograms = config.programs.dsh;
in
{
  # ── programs.dsh — the installation ────────────────────────────────────
  options.programs.dsh = {
    enable = lib.mkEnableOption ''
      the dsh (DeepSeek Harness) command line application.

      This adds `dsh` to home.packages.
    '';

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.dsh;
      description = "The dsh package to install.";
    };
  };

  # ── services.dsh — the daemon ──────────────────────────────────────────
  options.services.dsh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable the dsh (DeepSeek Harness) user service.
        Runs the web profile in the background.
      '';
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.dsh;
      description = "The dsh package to use for the service.";
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

  config = lib.mkMerge [
    # ── programs.dsh — the installation ────────────────────────────────
    (lib.mkIf cfgPrograms.enable {
      home.packages = [ cfgPrograms.package ];
    })

    # ── services.dsh — the daemon ──────────────────────────────────────
    (lib.mkIf cfg.enable {
      # Ensure pnpm is available for bundle installation
      home.packages = [ pkgs.pnpm ];

      systemd.user.services.dsh = {
        Unit = {
          Description = "DeepSeek Harness (dsh) - ${cfg.profile} profile";
          After = [ "network.target" ];
          Wants = [ "network.target" ];
        };

        # Pre-start: install missing profile bundles if needed
        Service = {
          Type = "simple";
          ExecStartPre = lib.mkIf cfg.autoInstallBundles ''
            ${cfg.package}/bin/dsh plugin --profile ${cfg.profile} install
          '';
          ExecStart = "${cfg.package}/bin/dsh ${cfg.profile} ${lib.concatStringsSep " " cfg.extraArgs}";
          Restart = "on-failure";
          RestartSec = "10s";
          Environment = lib.mapAttrsToList (k: v: "${k}=${v}") cfg.serviceEnvironment;
        };

        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    })
  ];
}