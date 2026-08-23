{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.maiko.user;
in

{
  options.maiko.user.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable user account configuration";
  };

  config = lib.mkIf cfg.enable {
    users = {
      mutableUsers = false;
      users.maiko = {
        isNormalUser = true;
        extraGroups = lib.mkMerge [
          [ "wheel" ]
          (lib.mkIf config.virtualisation.virtualbox.guest.enable [ "vboxsf" ])
        ];
        # 密码哈希由 sops 管理（secrets/password.yaml），不再明文提交到仓库。
        # 修改密码：
        #   mkpasswd -m sha-512   # 生成新哈希
        #   sops secrets/password.yaml   # 更新 maiko 字段为新哈希
        hashedPassword = null;
        hashedPasswordFile = config.sops.secrets.maikoPasswordHash.path;

        # set fish as default shell
        shell = pkgs.fish;
      };
    };

    sops.secrets.maikoPasswordHash = {
      sopsFile = ../secrets/password.yaml;
      key = "maiko";
      # 确保在创建用户（useradd）之前完成解密
      neededForUsers = true;
    };
  };
}
