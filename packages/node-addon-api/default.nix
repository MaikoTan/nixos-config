{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "node-addon-api";
  version = "8.9.2";

  src = fetchurl {
    url = "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.2.tgz";
    sha256 = "sha256-TNZWmFQbGaM/eY8dwlwCxu0cnXdJuIJLGhzOzdGXyOo=";
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/include
    # The npm package has the headers in the root
    tar xzf $src
    cp -r package/* $out/include/
  '';
}