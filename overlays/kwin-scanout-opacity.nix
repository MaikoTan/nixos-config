# 给 KWin 打补丁修复透明窗口闪烁：
#
# 用户设置的窗口透明度（修饰键+滚轮、窗口规则、translucency 特效）挂在
# WindowItem 上，是持有客户缓冲区的 SurfaceItem 的**祖先** item。
# workspacescene.cpp 的 isCandidate() 只检查 SurfaceItem 自身的 opacity，
# 半透明窗口仍可能被选为 direct scanout（硬件直通）候选——而扫描输出路径
# 不应用 item 透明度（源码里的 TODO 注释），窗口就被全不透明地显示。
# 下一帧合成器重新接管时透明度又生效，来回切换即肉眼可见的闪烁。
#
# 修法：isCandidate() 沿父链检查，祖先任一 opacity < 1 就退出候选。
# 完全不透明的窗口（全屏视频等）保留 direct scanout。
# 上游 TODO: https://invent.kde.org/plasma/kwin/-/blob/v6.8.1/src/scene/workspacescene.cpp
_final: prev: {
  kdePackages = prev.kdePackages.overrideScope (
    kfinal: kprev: {
      kwin = kprev.kwin.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          # 当 nixpkgs 更新 kwin 导致 patch 不能干净应用时，这里会在构建期
          # 直接报错——届时检查上游是否已修复（TODO 是否已移除），若是则删除
          # 本 overlay。
          ./kwin-scanout-opacity.patch
        ];
      });
    }
  );
}
