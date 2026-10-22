# Android 工具链：官方 `android` CLI + 用户目录下的完整 SDK。
# SDK 不由 Nix 管理，组件通过 `android sdk install` 安装到 ~/Android/Sdk。
{
  config,
  lib,
  pkgs,
  ...
}:

let
  sdkRoot = "${config.home.homeDirectory}/Android/Sdk";
in
{
  home = lib.mkIf config.maiko.hm.android {
    packages = [
      pkgs.android-studio-tools
    ];

    sessionVariables = {
      ANDROID_HOME = sdkRoot;
      ANDROID_SDK_ROOT = sdkRoot;
    };

    # 把 SDK 内的 platform-tools (adb) 与 emulator 加入 PATH。
    sessionPath = [
      "$ANDROID_HOME/platform-tools"
      "$ANDROID_HOME/emulator"
    ];
  };
}
