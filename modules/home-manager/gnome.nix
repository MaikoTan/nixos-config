{ lib, pkgs, ... }:

{
  home.packages = lib.mkMerge [
    # GNOME Shell extensions
    (with pkgs.gnomeExtensions; [
      blur-my-shell # Blur effect for GNOME Shell
      gsconnect # KDE Connect integration
      dash-to-dock # Dock
      unite # Window management
    ])
    # Custom overrides for GNOME Shell extensions
    [
      # wallhub # Wallpaper changer
      (pkgs.gnomeExtensions.wallhub.overrideAttrs (oldAttrs: {
        # modify the metadata.json to bump the gnome version to 48
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.jq ];
        postPatch = (oldAttrs.postPatch or "") + ''
          # add "48" to shell-version only if it's missing
          jq 'if (.["shell-version"] | index("48")) then . else .["shell-version"] += ["48"] end' metadata.json > metadata.json.tmp && mv metadata.json.tmp metadata.json
        '';
      }))
    ]
    # Other GNOME related packages
    (with pkgs; [
      gnome-shell-extensions # Core GNOME Shell extensions
      gnome-tweaks
      dconf
      # Several useful desktop applications
      remmina # remote desktop client
    ])
  ];
}
