{ inputs }:
let
  overlays = [
    inputs.android-nixpkgs.overlays.default
    inputs.angrr.overlays.default
    inputs.statix.overlays.default
  ];

  nixpkgsConfig = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    android_sdk.accept_license = true;
  };
in
{
  inherit overlays nixpkgsConfig;

  mkPkgs =
    system:
    import inputs.nixpkgs {
      inherit system overlays;
      config = nixpkgsConfig;
    };
}
