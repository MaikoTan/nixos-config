{
  inputs,
  ...
}:

{
  imports = [
    # nixpkgs 内置的 qemu-vm 模块：提供 system.build.vm（供 nixos-rebuild build-vm 使用）、
    # virtualisation.* 选项以及以 mkOverride 提供的根文件系统（保证 toplevel 可求值）。
    # 这是 nixos-generators（已废弃）vm 格式的现代替代。
    "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
    inputs.vscode-server.nixosModules.default
    ../../profiles/desktop.nix
    ../../profiles/vm.nix
  ];

  # 注意：此 VM 仅用于测试桌面配置，不要整体导入 machines/company/config.nix，
  # 否则会连带继承 company 的专属服务（samba / github-runners / zerotier /
  # clash-verge / 公司网络等）以及 company 的磁盘布局（hardware.nix）。

  virtualisation = {
    memorySize = 4096;
    cores = 2;
  };

  time.timeZone = "Asia/Shanghai";

  maiko.nix.useChinaMirrors = true;

  services.vscode-server.enable = true;

  networking.hostName = "nixos-vm";
}
