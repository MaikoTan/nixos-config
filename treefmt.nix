{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { pkgs, lib, ... }:
    {
      treefmt = {
        projectRootFile = "LICENSE";
        programs = {
          nixfmt = {
            enable = pkgs.lib.meta.availableOn pkgs.stdenv.buildPlatform pkgs.nixfmt.compiler;
            package = pkgs.nixfmt;
            width = 120;
          };
          shellcheck.enable = true;
          deno.enable = true;
          ruff = {
            check = true;
            format = true;
          };
        };
      };
    };
}
