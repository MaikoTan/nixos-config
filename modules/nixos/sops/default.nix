{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.maiko.sops;
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

  config = lib.mkIf cfg.enable {
    sops.age = {
      keyFile = "/var/lib/sops-nix/age/keys.txt";
    };

    # 注意：不要设置 sops.defaultSopsFile —— 所有 secret 必须显式指定 sopsFile，
    # 这样漏写时会在 eval 阶段直接报错，而不是在激活时才失败。
    environment.systemPackages = with pkgs; [
      sops
      age
    ];
  };
}
