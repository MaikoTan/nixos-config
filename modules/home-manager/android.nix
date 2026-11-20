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
      # Cap the V8 old space; app-plus builds peaked at ~4.6 GiB RSS.
      NODE_OPTIONS = "--max-old-space-size=4096";
    };

    # Replace the pre-existing Android Studio file on first activation.
    file.".gradle/gradle.properties".force = true;

    # 把 SDK 内的 platform-tools (adb) 与 emulator 加入 PATH。
    sessionPath = [
      "$ANDROID_HOME/platform-tools"
      "$ANDROID_HOME/emulator"
    ];
  };

  programs = lib.mkIf config.maiko.hm.android {
    # Fewer workers, a smaller Kotlin daemon, and a Gradle daemon that exits
    # after 10 idle minutes. Proxy settings live in machines/company/home.nix.
    gradle = {
      enable = true;
      # Projects use ./gradlew; don't put Gradle on PATH.
      package = null;
      settings = {
        "org.gradle.configuration-cache" = false;
        "org.gradle.workers.max" = 4;
        "org.gradle.daemon.idletimeout" = 600000;
        "kotlin.daemon.jvmargs" = "-Xmx1g";
        "org.gradle.jvmargs" = "-Xmx2g -XX:MaxMetaspaceSize=512m";
      };
    };
  };
}
