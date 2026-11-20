{
  imports = [
    ../../modules/home-manager
  ];

  maiko.hm.desktop = true;
  maiko.hm.android = true;

  programs.gradle.settings = {
    "systemProp.http.proxyHost" = "127.0.0.1";
    "systemProp.http.proxyPort" = "7890";
    "systemProp.http.nonProxyHosts" = "localhost|192.168.*|127.*|10.0.*";
    "systemProp.https.proxyHost" = "127.0.0.1";
    "systemProp.https.proxyPort" = "7890";
    "systemProp.https.nonProxyHosts" = "localhost|192.168.*|127.*|10.0.*";
    "systemProp.socksProxyHost" = "localhost";
    "systemProp.socksProxyPort" = "7890";
  };
}
