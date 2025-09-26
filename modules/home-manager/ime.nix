{ pkgs, ... }:

{
  home.file = {
    "fcitx5/rime/default.custom.yaml" = {
      text = ''
        patch:
          schema_list:
            - schema: double_pinyin
            - schema: luna_pinyin
            - schema: japanese
      '';
      target = "./.local/share/fcitx5/rime/default.custom.yaml";
    };
  };

  home.packages = with pkgs; [
    # Rime Schema Repository
    brise

    # GNOME Input Method Panel
    gnomeExtensions.kimpanel
  ];
}
