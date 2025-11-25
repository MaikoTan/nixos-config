{ ... }:

{
  imports = [
    ./mirrors.nix
  ];

  config.nix.settings = {
    /*
      Configuration for trusted users in Nix.

      This section specifies the users who are allowed to perform privileged Nix operations.
      - "root": The root user has full administrative privileges.
      - "@wheel": Members of the wheel group are also granted administrative privileges.
    */
    trusted-users = [
      "root"
      "@wheel"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "maiko-nixos-build.cachix.org-1:4EC5TVcsNL76xt7aqVoBpK0PoXPXuOF/kTLyjFyb8SM="
    ];
  };

  config.nix.extraOptions = ''
    experimental-features = nix-command flakes ca-derivations
  '';
}
