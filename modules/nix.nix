{ ... }:

{
  nixpkgs.config.allowUnfree = true;

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
    substituters = if config.time.timeZone == "Asia/Shanghai" then [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ] else config.nix.settings.substituters or [];
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes ca-derivations
  '';
}
