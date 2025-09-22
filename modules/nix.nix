{ config, lib, ... }:

{
  config.nix.settings = {
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
     * Prepend China mirrors to the list of Nix substituters if the `use-china-mirrors` option is enabled.
     * This is useful for users in China to improve download speeds and reliability when fetching packages.
     */
    substituters = lib.mkMerge[
      (lib.mkIf (config.nix.use-china-mirrors) [
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

  config.nix.extraOptions = ''
    experimental-features = nix-command flakes ca-derivations
  '';

  options.nix.use-china-mirrors = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Whether to use China mirrors for Nix package management.
      When enabled, it configures the `substituters` option to use
      mirrors from Chinese universities and the official NixOS cache.
    '';
  };
}
