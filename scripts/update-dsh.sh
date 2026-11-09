#!/usr/bin/env bash
# 更新 dsh（@deepseek-ai/dsh）到上游最新版本。
#
# 为什么不能只跑 nvfetcher：nvfetcher 只更新 tarball 的 version/src，而
# dsh 用 buildNpmPackage 构建，还依赖两个不会自动更新的东西：
#   - packages/dsh/package-lock.json：固定整个 npm 依赖闭包
#   - packages/dsh/default.nix 里的 npmDepsHash
# 版本一变这两者就失效，构建会以 ENOTCACHED / hash 不匹配失败。
# 所以更新 dsh 一律走本脚本，它会依次完成 nvfetcher、lockfile 重建、
# hash 回写和构建验证。
#
# 用法：./scripts/update-dsh.sh
set -euo pipefail

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo"

echo "==> nvfetcher 更新 dsh 源码"
# 必须显式 -o：nvfetcher 默认把产物写到 cwd 下的 _sources，而不是配置文件
# 旁边，漏掉这个参数会在仓库根目录留下无用的 _sources/。
nix run nixpkgs#nvfetcher -- -c packages/nvfetcher.toml -o packages/_sources --filter 'dsh'

# version 与 src 都是惰性的，取 version 不需要真正的 fetcher。
version=$(nix eval --raw --impure --expr '
  (import ./packages/_sources/generated.nix {
    fetchgit = null;
    fetchurl = null;
    fetchFromGitHub = null;
    dockerTools = null;
  }).dsh.version')
echo "==> 上游版本: $version"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# npm tarball 只带 package.json，没有 lockfile；必须在解包目录里现场解析
# 出一份，构建时才能用 npm ci 离线复现。
echo "==> 下载 tarball 并重建 lockfile"
nix shell nixpkgs#curl nixpkgs#nodejs_22 -c bash -c '
  set -euo pipefail
  curl -fsSL -o "$0/dsh.tgz" "https://registry.npmjs.org/@deepseek-ai/dsh/-/dsh-$1.tgz"
  tar -xzf "$0/dsh.tgz" -C "$0"
  cd "$0/package"
  npm install --package-lock-only --ignore-scripts --no-audit --no-fund
' "$tmp" "$version"

cp "$tmp/package/package-lock.json" packages/dsh/package-lock.json

echo "==> 计算并回写 npmDepsHash"
hash=$(nix shell nixpkgs#prefetch-npm-deps -c prefetch-npm-deps packages/dsh/package-lock.json)
sed -i -E "s|npmDepsHash = \"sha256-[^\"]*\"|npmDepsHash = \"$hash\"|" packages/dsh/default.nix

# 用 flake 里锁定的 nixpkgs + dsh 相关 overlay 单独构建，比整机
# home-manager 构建快，且能立刻暴露 hash / lockfile 问题。
echo "==> 构建验证"
nix build --no-link --print-out-paths --impure --expr '
let
  repo = "'"$repo"'";
  flake = builtins.getFlake ("path:" + repo);
  pkgs = import flake.inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
    overlays = [
      (import (repo + "/overlays/node-addon-api.nix"))
      (import (repo + "/overlays/node-addon-require-builtin.nix"))
      (import (repo + "/overlays/dsh.nix"))
    ];
  };
in pkgs.dsh'

echo "==> 完成：$version"
