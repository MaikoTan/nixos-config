{
  inputs,
  ...
}:

{
  imports = [
    inputs.vscode-server.nixosModules.default
    ../../profiles/desktop.nix
    ../../profiles/vm.nix
  ];

  # 注意：此 VM 仅用于测试桌面配置，不要整体导入 machines/company/config.nix，
  # 否则会连带继承 company 的专属服务（samba / github-runners / zerotier /
  # clash-verge / 公司网络等）以及 company 的磁盘布局（hardware.nix）。

  time.timeZone = "Asia/Shanghai";

  maiko.nix.useChinaMirrors = true;

  services.vscode-server.enable = true;

  networking.hostName = "nixos-vm";
}