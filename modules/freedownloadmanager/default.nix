{
  lib,
  stdenv,
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  patchelf,
  udev,
  libdrm,
  libpqxx,
  unixodbc,
  gst_all_1,
  libtiff,
  libxcb-cursor,
  libxcb-wm,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libpulseaudio,
  libmysqlclient,
  oracle-instantclient,
  firebird,
}:

let
  # 由 nvfetcher 生成（见 nvfetcher.toml），升级时修改版本号并重新运行 nvfetcher
  sources = import ./_sources/generated.nix {
    inherit
      fetchgit
      fetchurl
      fetchFromGitHub
      dockerTools
      ;
  };
in

stdenv.mkDerivation rec {
  pname = "freedownloadmanager";
  version = sources.freedownloadmanager.version;

  src = sources.freedownloadmanager.src;

  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
    patchelf
  ];

  buildInputs = [
    libdrm
    libpqxx
    unixodbc
    stdenv.cc.cc
    libmysqlclient
    oracle-instantclient
    firebird
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ])
  ++ [
    libtiff
    libxcb-cursor # libxcb-cursor.so.0
    libxcb-wm # libxcb-icccm.so.4
    libxcb-image # libxcb-image.so.0
    libxcb-keysyms # libxcb-keysyms.so.1
    libxcb-render-util # libxcb-render-util.so.0
    libpulseaudio
  ];

  runtimeDependencies = [
    (lib.getLib udev)
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r opt/freedownloadmanager $out
    cp -r usr/share $out
    ln -s $out/freedownloadmanager/fdm $out/bin/${pname}

    substituteInPlace $out/share/applications/freedownloadmanager.desktop \
      --replace 'Exec=/opt/freedownloadmanager/fdm' 'Exec=${pname}' \
      --replace "Icon=/opt/freedownloadmanager/icon.png" "Icon=$out/freedownloadmanager/icon.png"

    runHook postInstall
  '';

  postFixup = ''
    rm -rf $out/freedownloadmanager/plugins/sqldrivers/libqsqlmimer.so || true
    patchelf --replace-needed libclntsh.so.23.1 libclntsh.so $out/freedownloadmanager/plugins/sqldrivers/libqsqloci.so
    patchelf --set-rpath ${libmysqlclient}/lib/mariadb \
      --replace-needed libmysqlclient.so.21 libmysqlclient.so $out/freedownloadmanager/plugins/sqldrivers/libqsqlmysql.so
    patchelf --replace-needed libtiff.so.5 libtiff.so $out/freedownloadmanager/plugins/imageformats/libqtiff.so
  '';

  meta = with lib; {
    description = "A smart and fast internet download manager";
    homepage = "https://www.freedownloadmanager.org";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ maikotan ];
  };
}
