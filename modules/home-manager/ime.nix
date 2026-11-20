{ config, lib, ... }:

# Desktop-only (fcitx5/rime input method).
{
  config = lib.mkIf config.maiko.hm.desktop {
    home.file = {
      "fcitx5/rime/default.custom.yaml" = {
        text = ''
          patch:
            schema_list:
              - schema: double_pinyin
              - schema: luna_pinyin
              - schema: phing_im_tlpa
              - schema: phing_im_poj
              - schema: flypy
              - schema: japanese
        '';
        target = "./.local/share/fcitx5/rime/default.custom.yaml";
      };
    };
  };
}
