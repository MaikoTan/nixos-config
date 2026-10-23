{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.maiko.hm.magpie {
    home.packages = with pkgs; [
      magpie-cli
      (writeShellApplication {
        name = "magpie-sops-backup";
        runtimeInputs = [
          coreutils
          git
          sops
        ];
        text = ''
          set -euo pipefail
          umask 077

          repo_root="$(git rev-parse --show-toplevel)"
          providers_file="''${XDG_CONFIG_HOME:-$HOME/.config}/magpie/providers.json"

          if [ ! -f "$providers_file" ]; then
            echo "Magpie provider file not found: $providers_file" >&2
            exit 1
          fi

          backup_file="$repo_root/secrets/magpie-providers.json"
          temp_file="$(mktemp "$repo_root/secrets/.magpie-providers.json.XXXXXX")"
          trap 'rm -f "$temp_file"' EXIT

          sops --encrypt \
            --config "$repo_root/.sops.yaml" \
            --filename-override "secrets/magpie-providers.json" \
            --input-type json \
            --output-type json \
            "$providers_file" > "$temp_file"
          mv -- "$temp_file" "$backup_file"
          trap - EXIT

          printf 'Encrypted Magpie provider backup updated: %s\n' "$backup_file"
        '';
      })
    ];

    # Provider 配置由 Magpie 在运行期维护；密钥备份通过 magpie-sops-backup 加密到仓库。
    systemd.user.services.magpie = {
      Unit = {
        Description = "Magpie local AI gateway";
      };

      Service = {
        ExecStart = "${pkgs.magpie-cli}/bin/magpie serve";
        Restart = "on-failure";
        RestartSec = "5s";
        UMask = "0077";
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
