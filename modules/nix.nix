{ config, lib, ... }:

{
  nix.settings = {
    /*
     * Configuration for trusted users in Nix.
     * 
     * This section specifies the users who are allowed to perform privileged Nix operations.
     * - "root": The root user has full administrative privileges.
     * - "@wheel": Members of the wheel group are also granted administrative privileges.
     */
    trusted-users = [
      "root"
      "@wheel"
    ];

    /*
     * This configuration sets the `substituters` option for Nix package manager.
     * If the system's time zone is set to "Asia/Shanghai", it uses a list of
     * substituters from various Chinese university mirrors and the official NixOS cache.
     * Otherwise, it falls back to the default substituters specified in `config.nix.settings.substituters`.
     */
    substituters = lib.mkMerge[
      (lib.mkIf (config.time.timeZone == "Asia/Shanghai") [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
      ])
      [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ]
    ];
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes ca-derivations
  '';
}
