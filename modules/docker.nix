{ lib, ... }:

{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      ipv6 = true;
      registry-mirrors = [
        # China Mainland Mirrors
        "https://docker.mirrors.ustc.edu.cn"
        "https://mirror.ccs.tencentyun.com"
      ];
    };
  };

  users.users.maiko.extraGroups = lib.mkAfter [ "docker" ];
}
