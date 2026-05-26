{
  inputs,
  lib,
  pkgs,
  ...
}:

let

  package = inputs.code-insiders.packages."x86_64-linux".vscode-insider.overrideAttrs (oldAttrs: {
    buildInputs =
      oldAttrs.buildInputs
      ++ (with pkgs; [
        webkitgtk_4_1
        libsoup_3
        openssl
        curl
        musl
      ]);
    # Copied and adapted from https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vscode/generic.nix#L382
    postPatch =
      lib.optionalString pkgs.stdenv.hostPlatform.isLinux (
        # disable update checks
        ''
          tmpProductJson="$(mktemp)"
          jq 'del(.updateUrl, .backupUpdateUrl)' resources/app/product.json > "$tmpProductJson"
          mv "$tmpProductJson" resources/app/product.json
        ''
        # this is a fix for "save as root" functionality
        + ''
          packed="resources/app/node_modules.asar"
          unpacked="resources/app/node_modules"
          asar extract "$packed" "$unpacked"
          substituteInPlace $unpacked/@vscode/sudo-prompt/index.js \
            --replace-fail "/usr/bin/pkexec" "/run/wrappers/bin/pkexec" \
            --replace-fail "/bin/bash" "${pkgs.bash}/bin/bash"
          rm -rf "$packed"
        ''
        # without this symlink loading JsChardet, the library that is used for auto encoding detection when files.autoGuessEncoding is true,
        # fails to load with: electron/js2c/renderer_init: Error: Cannot find module 'jschardet'
        # and the window immediately closes which renders VSCode unusable
        # see https://github.com/NixOS/nixpkgs/issues/152939 for full log
        + ''
          ln -rs "$unpacked" "$packed"
        ''
      )
      + (
        let
          ripgrepPath = "@vscode/ripgrep-universal/bin/${lib.toLower pkgs.stdenv.hostPlatform.uname.system}-${pkgs.stdenv.hostPlatform.efiArch}/rg";
          vscodeRipgrep =
            if pkgs.stdenv.hostPlatform.isDarwin then
              if lib.versionAtLeast oldAttrs.version "1.94.0" then
                "Contents/Resources/app/node_modules/${ripgrepPath}"
              else
                "Contents/Resources/app/node_modules.asar.unpacked/${ripgrepPath}"
            else
              "resources/app/node_modules/${ripgrepPath}";
        in
        if !false then
          ''
            rm ${vscodeRipgrep}
            ln -s ${pkgs.ripgrep}/bin/rg ${vscodeRipgrep}
          ''
        else
          ''
            chmod +x ${vscodeRipgrep}
          ''
      );
  });
  editor = "${package}/bin/code-insiders --wait";

in

{
  programs = {
    vscode = {
      enable = true;
      # isInsiders = true; # No need to set this option since the flake input already set it in their package definition.

      mutableExtensionsDir = true; # Allow VS Code to manage extensions as well as user settings.
      inherit package;
    };

    git.settings = {
      core = {
        inherit editor;
      };
    };

    gh.settings = {
      inherit editor;
    };
  };
}
