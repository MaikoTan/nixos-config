# Override the github-copilot-app version with the nvfetcher-managed release.
# Only `version` and `src` are replaced; the rest of the build logic is inherited
# from the upstream nixpkgs definition, so there is no need to maintain a
# full package definition here.
# Update: `nix run nixpkgs#nvfetcher -c packages/github-copilot-app/nvfetcher.toml`
final: prev:
let
  sources = import ../packages/_sources/generated.nix {
    inherit (final)
      fetchgit
      fetchurl
      fetchFromGitHub
      dockerTools
      ;
  };
  pkg = sources.github-copilot-app;

  # Keep the same OpenSSL version as the upstream nixpkgs buildInputs.
  # Note: openssl is a multi-output package with "bin" listed first, so the
  # default output is "bin" -- the runtime libraries live in ".out" and must be
  # referenced explicitly.
  openssl = final.openssl_3_5.out;
in
{
  github-copilot-app = prev.github-copilot-app.overrideAttrs (oldAttrs: {
    inherit (pkg) version src;

    # Mitigate WebKit rendering stalls: the app overwrites the WEBKIT_*
    # variables with setenv() on startup, which forces WebKit back to
    # software rendering (HeadedCompositor spinning, CPU pinned at 100%).
    # Injecting the variables through the gapps C wrapper makes the app see
    # them as already set and keep them (apply_environment_overrides), so the
    # hardware accelerated path is preserved.
    #
    # All three variables must be exactly "0":
    #   WEBKIT_DISABLE_DMABUF_RENDERER=0        any other value disables the whole acceleration
    #   WEBKIT_DMABUF_RENDERER_FORCE_SHM=0      any other value drops the Hardware transfer mode
    #   WEBKIT_DISABLE_COMPOSITING_MODE=0       any other value disables accelerated compositing
    preFixup = (oldAttrs.preFixup or "") + ''
      gappsWrapperArgs+=(
        --set WEBKIT_DISABLE_DMABUF_RENDERER 0
        --set WEBKIT_DMABUF_RENDERER_FORCE_SHM 0
        --set WEBKIT_DISABLE_COMPOSITING_MODE 0
      )
    '';

    # Fix the crash caused by an abort during initialisation of the voice
    # transcription component (Microsoft AI Foundry Local).
    #
    # Root cause: Microsoft.AI.Foundry.Local.Core.so is a .NET NativeAOT
    # binary whose System.Security.Cryptography.Native apibridge probes for a
    # usable OpenSSL by dlopen()ing the bare sonames "libssl.so.3",
    # "libssl.so.1.1", ... in turn. The RUNPATH of that .so is
    # "15814ORIGIN:$ORIGIN", and autoPatchelfHook never adds the openssl from
    # buildInputs to it -- a dlopen() of a bare soname does not go through
    # DT_NEEDED resolution, so the probe always fails. The result is
    # fwrite(stderr, "No usable version of libssl was found") followed by
    # abort(), which kills the whole app process with SIGABRT (core-dump).
    #
    # Fix: rely on $ORIGIN and place the OpenSSL runtime libraries next to
    # that .so, so dlopen("libssl.so.3") resolves in place.
    # libcrypto.so.3 is copied as well because it is a DT_NEEDED entry of
    # libssl.so.3 and would otherwise not be found from the app directory.
    postFixup = (oldAttrs.postFixup or "") + ''
      foundryDir="$out/lib/GitHub Copilot"
      if [ -d "$foundryDir" ]; then
        cp -a ${openssl}/lib/libssl.so.3 "$foundryDir/libssl.so.3"
        cp -a ${openssl}/lib/libcrypto.so.3 "$foundryDir/libcrypto.so.3"
        chmod u+w "$foundryDir/libssl.so.3" "$foundryDir/libcrypto.so.3"
      fi
    '';
  });
}
