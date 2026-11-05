# Native module for dsh (built from source with NAPI v9)
_final: _prev: {
  node-addon-require-builtin = _final.callPackage ../packages/node-addon-require-builtin {
    inherit (_final) node-addon-api node-gyp;
  };
}
