# 从本地 derivation 提供 freedownloadmanager（闭源 deb 打包，来源由 nvfetcher 管理）。
_final: _prev: {
  freedownloadmanager = _final.callPackage ../packages/freedownloadmanager { };
}
