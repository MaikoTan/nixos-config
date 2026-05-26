{
  lib,
  stdenv,
  fetchurl,
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

stdenv.mkDerivation rec {
  pname = "freedownloadmanager";
  version = "6.24";

  src = fetchurl {
    url = "https://files2.freedownloadmanager.org/6/latest/freedownloadmanager.deb";
    hash = "sha256-A8PGbnsNCO00c/XPIDaW7JdN++tXScpKCI5gJnN6O+U=";
  };

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
