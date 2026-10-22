{ lib, pkgs, ... }:

{
  imports = [
    ../modules/nixos/nix
    ../modules/nixos/packages/default.nix
    ../modules/nixos/openssh/default.nix
    ../modules/nixos/programs/default.nix
    ../modules/nixos/user/default.nix
    ../modules/nixos/sops/default.nix
    ../modules/nixos/vscode-server/default.nix
  ];

  maiko = {
    nix = {
      enable = true;
      gc.enable = true;
    };
    packages.enable = true;
    openssh.enable = true;
    programs.enable = true;
    user.enable = true;
    sops.enable = true;
    vscode-server.enable = true;
  };

  # This is required for vscode-server to work properly,
  # and it also makes other programs easier to be used in WSL.
  programs.nix-ld.enable = true;

  # 额外提供 X11/xcb 等图形库，让用户自管的 Android SDK（~/Android/Sdk）
  # 中的 emulator 能在 NixOS 上直接运行（其二进制没有指向 nix store 的 RPATH）。
  programs.nix-ld.libraries = with pkgs; [
    libx11
    libxcb
    libxcb-cursor
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxkbcommon
    libxkbfile
    libxrandr
    libxrender
    libxshmfence
    libxtst
    libice
    libsm
    alsa-lib
    dbus
    expat
    fontconfig
    freetype
    libbsd
    libdrm
    libgbm
    libGL
    libpng
    libtiff
    ncurses
    nss
    nspr
    libpulseaudio
  ];

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  console = {
    font = lib.mkDefault "Lat2-Terminus16";
    useXkbConfig = lib.mkDefault true; # use xkb.options in tty.
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = lib.mkDefault "25.11"; # Did you read the comment?
}
