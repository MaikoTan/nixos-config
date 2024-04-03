{ ... }:

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
    "fcitx5/profile" = {
      text = ''
[Groups/0]
# Group Name
Name=Default
# Layout
Default Layout=us
# Default Input Method
DefaultIM=rime

[Groups/0/Items/0]
# Name
Name=keyboard-us

[Groups/0/Items/1]
# Name
Name=keyboard-fr

[Groups/0/Items/2]
# Name
Name=keyboard-de

[Groups/0/Items/3]
# Name
Name=rime
# Layout
Layout=us

[GroupOrder]
0=Default
      '';
      target = "./.config/fcitx5/profile";
    };
  };
}
