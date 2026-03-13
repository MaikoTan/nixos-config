{ inputs }:
let
  shared = import ./lib.nix { inherit inputs; };
in
{
  maiko = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = shared.mkPkgs "x86_64-linux";
    extraSpecialArgs = { inherit inputs; };
    modules = [
      ./../modules/home-manager
    ];
  };
}
