{
  inputs,
  ...
}:

let

  package = inputs.code-insiders.packages."x86_64-linux".vscode-insider.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs;
    # TODO: auto-patchelf did not work for this package since it requires a bunch of GPU and CUDA
    # libraries, we just remove the onnxruntime temporarily to make it work for now, and wait for
    # the upstream to fix the issue.
    postInstall = (oldAttrs.postInstall or "") + ''
      rm -f $out/lib/vscode/resources/app/node_modules/onnxruntime-node/bin/napi-v6/linux/x64/libonnxruntime_providers_cuda.so
      rm -f $out/lib/vscode/resources/app/node_modules/onnxruntime-node/bin/napi-v6/linux/x64/libonnxruntime_providers_tensorrt.so
      rm -f $out/lib/vscode/resources/app/node_modules.asar.unpacked/onnxruntime-node/bin/napi-v6/linux/x64/libonnxruntime_providers_cuda.so
      rm -f $out/lib/vscode/resources/app/node_modules.asar.unpacked/onnxruntime-node/bin/napi-v6/linux/x64/libonnxruntime_providers_tensorrt.so
    '';
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
