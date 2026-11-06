#!/usr/bin/env bash
# 手动把仓库里的 rescue 系统同步到备用分区（nvme0n1p2, label=rescue）。
#
# 用法：sudo ./scripts/sync-rescue.sh [仓库路径]
#   不传路径时以脚本所在目录的上一级作为 flake 根目录。
#
# 与 `nh os boot`/`switch` 完全解耦：主系统配置不引用 rescue，因此
# rescue 的 1.6G 依赖不会进入主系统 closure，也不会被主系统 generation
# 当成 GC root。只有显式运行本脚本时才求值、构建、写入。
set -euo pipefail

repo=${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}
# path: 强制按目录内容求值，包含尚未提交的改动；否则 nix 会把 git 仓库
# 当作 git+file flake，只认已提交的文件，容易把旧配置同步进 rescue 分区。
flake="path:$repo"
rescue_dev=/dev/disk/by-label/rescue
esp_dev=/dev/disk/by-label/boot
mnt=/mnt/rescue-sync

if [ "$(id -u)" -ne 0 ]; then
  echo "请以 root 运行（sudo $0）" >&2
  exit 1
fi
for dev in "$rescue_dev" "$esp_dev"; do
  if [ ! -e "$dev" ]; then
    echo "找不到 $dev，请确认本机是 company 且分区标签正确" >&2
    exit 1
  fi
done
if mountpoint -q "$mnt"; then
  echo "$mnt 已被挂载（可能正在人工救援），跳过" >&2
  exit 1
fi

# 在脚本目录之外求值，避免 nix 把仓库当作普通路径源时受 cwd 影响。
# --no-link 只要 store 路径；赶时间可先 `nix build .#nixosConfigurations.rescue...`
# 复用缓存，脚本本身每次都会走一遍 eval（几秒）。
echo "==> 求值 rescue toplevel（flake: $flake）"
toplevel=$(nix eval --raw "$flake#nixosConfigurations.rescue.config.system.build.toplevel.outPath")

echo "==> 确保 toplevel 已在本机 store：$toplevel"
nix build --no-link "$flake#nixosConfigurations.rescue.config.system.build.toplevel"

# nixos-install 与 nix 工具都从 nixpkgs 现场取，不依赖主系统配置。
installer=$(nix eval --raw nixpkgs#nixos-install.outPath)/bin/nixos-install
nix_env=$(nix eval --raw nixpkgs#nix.outPath)/bin/nix-env
nix_store=$(nix eval --raw nixpkgs#nix.outPath)/bin/nix-store

mkdir -p "$mnt"
trap 'umount -R "$mnt" 2>/dev/null || true' EXIT

# 快速路径：已装的就是这个 generation 时只读挂载 + 一次 readlink 即可。
mount -o ro "$rescue_dev" "$mnt"
installed=$(readlink -f "$mnt/nix/var/nix/profiles/system" 2>/dev/null || true)
if [ "$installed" = "$toplevel" ]; then
  echo "==> rescue 分区已是 $toplevel，无需改动"
  exit 0
fi

# rescue 的 GRUB 需要看到 ESP，才能把 /EFI/rescue/grubx64.efi 写进 p1。
mount -o remount,rw "$mnt"
mkdir -p "$mnt/boot/efi"
mount "$esp_dev" "$mnt/boot/efi"

echo "==> 安装 $toplevel 到 $rescue_dev"
"$installer" \
  --root "$mnt" \
  --system "$toplevel" \
  --no-channel-copy \
  --no-root-passwd

# 7.6G 分区不能攒旧 generation；rescue 自己启动后由 nix.gc 接管。
# profile 是 chroot store 的 gcroot，当前 generation 不会被 --gc 清掉。
echo "==> 清理旧 generation"
(
  "$nix_env" --store "$mnt" \
    -p "$mnt/nix/var/nix/profiles/system" --delete-generations old || true
  "$nix_store" --store "$mnt" --gc || true
)

echo "==> 完成。可用 GRUB 菜单里的 'Rescue system (from nvme0n1p2)' 启动。"
