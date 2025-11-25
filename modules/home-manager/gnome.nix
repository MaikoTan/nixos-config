{ lib, pkgs, ... }:

{
  home.packages = lib.mkMerge [
    # GNOME Shell extensions
    (with pkgs.gnomeExtensions; [
      appindicator # Tray icons support
      blur-my-shell # Blur effect for GNOME Shell
      dash-to-dock # Dock
      unite # Window management

      # wallhub # Wallpaper changer
      # TODO: unmaintained, but still works with GNOME 48 with a patch
      (wallhub.overrideAttrs (oldAttrs: {
        # modify the metadata.json to bump the gnome version to 48
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.jq ];
        postPatch = (oldAttrs.postPatch or "") + ''
          # add "48" to shell-version only if it's missing
          jq 'if (.["shell-version"] | index("48")) then . else .["shell-version"] += ["48"] end' metadata.json > metadata.json.tmp && mv metadata.json.tmp metadata.json
        '';
      }))
    ])
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
