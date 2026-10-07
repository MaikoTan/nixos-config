# 用 nvfetcher 管理的版本覆盖 github-copilot-app，仅替换 version 与 src，
# 其余构建逻辑沿用 nixpkgs 上游定义，省去维护整个包的负担。
# 更新：`nix run nixpkgs#nvfetcher -c packages/github-copilot-app/nvfetcher.toml`
final: prev:
let
  sources = import ../packages/_sources/generated.nix {
    inherit (final)
      fetchgit
      fetchurl
      fetchFromGitHub
      dockerTools
      ;
  };
  pkg = sources.github-copilot-app;
in
{
  github-copilot-app = prev.github-copilot-app.overrideAttrs (_: {
    version = pkg.version;
    src = pkg.src;
  });
}
