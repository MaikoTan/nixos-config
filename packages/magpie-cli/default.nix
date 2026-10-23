{
  lib,
  stdenvNoCC,
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}:

let
  # 由 nvfetcher 生成（见 ../nvfetcher.toml），升级时重新运行 nvfetcher 即可更新 hash。
  sources = import ../_sources/generated.nix {
    inherit
      fetchgit
      fetchurl
      fetchFromGitHub
      dockerTools
      ;
  };
in

stdenvNoCC.mkDerivation rec {
  pname = "magpie-cli";
  version = sources.magpie-cli.version;

  src = sources.magpie-cli.src;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/magpie"
    install -Dm644 ${./magpie.fish} "$out/share/fish/vendor_completions.d/magpie.fish"
    runHook postInstall
  '';

  meta = {
    description = "Command-line agent client";
    homepage = "https://usemagpie.ai";
    license = lib.licenses.unfree;
    mainProgram = "magpie";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ maikotan ];
  };
}
