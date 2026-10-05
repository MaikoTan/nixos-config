# Extra CLI programs: direnv, zoxide, jq, fastfetch.
{
  config,
  lib,
  ...
}:

{
  programs = lib.mkIf config.maiko.hm.extras {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
    };

    jq.enable = true;

    fastfetch = {
      enable = true;
      settings = {
        #
      };
    };
  };
}
