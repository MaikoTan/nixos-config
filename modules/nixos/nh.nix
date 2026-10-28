# nh —— Nix/NixOS/Home Manager 的统一 CLI 助手。
#
# 这里只启用 CLI 本身：`os`/`home` switch、`search`、`rom`、`dix` 这些日常
# 命令都很有用，但**不启用 nh 的定时清理**。垃圾回收已由 angrr 全权接管
# （见 ./nix/gc.nix），它的策略比 nh clean 保守得多（keep-latest-n 15、
# keep-since 14d、且保住 booted/current system），而 nh clean all 的默认值是
# --keep 1 + --keep-since 0h，两者并行会互相抢 gcroots/generations。
#
# 需要腾空间时仍可手动跑 `nh clean all --keep 5 --keep-since 7d`，把参数
# 对齐 angrr 的策略即可。

{
  config,
  lib,
  ...
}:

let
  cfg = config.maiko.nh;
in

{
  options.maiko.nh.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable nh, yet another Nix CLI helper";
  };

  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;

      # 定时清理交给 angrr，见文件头注释。
      clean.enable = false;

      # 指向仓库根目录，使 `nh os switch` / `nh home switch`
      # 无需额外参数即可工作。
      flake = toString ../..;
    };
  };
}
