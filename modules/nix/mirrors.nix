{ config, lib, ... }:

let

  cfg = config.maiko.nix;

in

{
  options.maiko.nix.useChinaMirrors = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Whether to use China mirrors for Nix package management.
      When enabled, it configures the `substituters` option to use
      mirrors from Chinese universities and the official NixOS cache.
    '';
  };

  /*
    Prepend China mirrors to the list of Nix substituters if the `use-china-mirrors` option is enabled.
    This is useful for users in China to improve download speeds and reliability when fetching packages.
  */
  config.nix.settings.substituters = lib.mkMerge [
    (lib.mkIf cfg.useChinaMirrors [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
    ])
    [
      "https://nix-community.cachix.org"
      "https://maiko-nixos-build.cachix.org"
      "https://statix.cachix.org"
      "https://cache.nixos.org"
    ]
  ];
}
