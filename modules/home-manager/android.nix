# Android SDK + Android Studio (heavy, desktop only).
{
  config,
  lib,
  pkgs,
  ...
}:

{
  android-sdk = lib.mkIf config.maiko.hm.android {
    enable = true;
    path = "${config.home.homeDirectory}/.android/sdk";
    packages =
      sdk: with sdk; [
        build-tools-36-1-0
        # cmdline-tools-latest
        cmdline-tools-22-0
        emulator
        system-images-android-36-google-apis-x86-64
        platforms-android-36
        sources-android-36
      ];
  };

  home.packages = lib.mkIf config.maiko.hm.android [
    pkgs.android-cli
  ];
}
