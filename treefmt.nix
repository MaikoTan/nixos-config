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
          deno = {
            enable = true;
            excludes = [
              "packages/_sources/*.json"
              # sops 密文（age 块 + MAC）不是常规 YAML/JSON，deno fmt 会
              # 重排版并破坏密文，因此整个 secrets/ 目录都要排除。
              "secrets/*.json"
              "secrets/*.yaml"
            ];
          };
          ruff = {
            check = true;
            format = true;
          };
        };
      };
    };
}
