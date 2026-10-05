{
  stdenvNoCC,
  fetchFromGitHub,
}:

let
  version = "1.2.6";
in

stdenvNoCC.mkDerivation {
  name = "miku-cursors";
  inherit version;

  src = fetchFromGitHub {
    owner = "supermariofps";
    repo = "hatsune-miku-windows-linux-cursors";
    rev = version;
    hash = "sha256-OQjjOc9VnxJ7tWNmpHIMzNWX6WsavAOkgPwK1XAMwtE=";
  };

  # 保留旧内联版本的原始字符串写法（含缩进），使 derivation hash 保持不变。
  buildPhase = "
      mkdir -p $out/share/icons/miku-cursor
      cp -r $src/miku-cursor-linux/* $out/share/icons/miku-cursor/
    ";
}
