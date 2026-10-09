# nixos-config

My own NixOS configurations

## Installation

- Clone this repository to any location you want.

```bash
git clone https://github.com/MaikoTan/nixos-config.git /usr/nixos-config
```

- [Create partitions for NixOS](https://nixos.org/manual/nixos/stable/#sec-installation-manual-partitioning)
  if you haven't done so.

- Run the following command to install NixOS.

```bash
nixos-install --option experimental-features 'nix-command flakes' --flake "/usr/nixos-config#<hostname>"
```

- If you are not using first-time installation, run the following command to
  switch to the new configuration.
  - If you encounter network issues, you may also try the mirror with option
    `--mirror`.

```bash
nixos-rebuild switch --option experimental-features 'nix-command flakes' --flake ".#<hostname>"
```

- Reboot your system.

```bash
reboot
```

## Update

- Run the following command to update the system.

```bash
./switch.fish
```

If you have changed anything managed by `dconf`, make sure to run the following
command (in fish shell) to update the `dconf` config.

```bash
./build.fish
```

## Structure

- `flake.nix` — Flake entry: machine definitions, overlay wiring, devShell
- `machines/<hostname>/` — Machine-specific configs (`config.nix` + generated
  `hardware.nix`)
- `profiles/` — Composition layer: which modules to enable per machine type
- `modules/nixos/` — Reusable NixOS modules (option + config pattern, enabled
  via `maiko.*` options). Flat modules live directly here (`desktop.nix`,
  `remote-desktop.nix`); grouped features live in per-feature subdirectories
  (`boot/`, `display-manager/`, `docker/`, `fonts/`, `ime/`, `nix/`, ...)
- `modules/home-manager/` — User-level configuration (fish, vscode, dconf,
  plasma). Split into per-feature files (`git.nix`, `extras.nix`,
  `packages.nix`, ...) plus subdirectories for `agents/`, `fish/`, `vscode/`.
  Individual features are toggled with the `maiko.hm.*` option set (see
  `modules/home-manager/machine.nix`)
- `packages/` — Locally maintained package derivations (`rime-tlpa`,
  `freedownloadmanager`, `miku-cursors`). These are packages, not modules:
  nothing here is imported by a NixOS or Home Manager module, and each is
  exposed to `pkgs` through an overlay in `overlays/`
- `overlays/` — One file per locally maintained package (`rime-tlpa.nix`,
  `freedownloadmanager.nix`, `miku-cursors.nix`), plus `default.nix` which
  returns the whole local set as a list. `flake.nix` splices it in with `++`
  between the third-party overlays. **Order matters** — it determines derivation
  resolution
- `lib/` — Shared helpers used by the flake and the local overlays
  (`rime-patched-pkgs.nix`)
- `secrets/` — SOPS-encrypted secrets (age)

### Per-machine Home Manager config

Home Manager configurations are keyed by `user@hostname` in `flake.nix`
(`maiko@company`, `maiko@wsl`). Each entry imports the shared module set
(`./modules/home-manager`) plus a per-machine entry point at
`machines/<host>/home.nix`, which toggles individual features via the
`maiko.hm.*` options (e.g. `maiko.hm.desktop = true;`).

### Adding a local package

1. Put the derivation under `packages/<name>/` (use `nvfetcher.toml` +
   `_sources/` if the upstream has no versioned URL).
2. Add `overlays/<name>.nix` exposing it via `final.callPackage`.
3. Register it in the list returned by `overlays/default.nix`.

Verify with
`nix build .#nixosConfigurations.company.config.system.build.toplevel` and
confirm the package's `outPath` is unchanged from before the move.

## Secrets

Secrets are managed with [sops-nix](https://github.com/Mic92/sops-nix) using age
keys.

- User key: `~/.config/sops/age/keys.txt`
- Host key: `/var/lib/sops-nix/age/keys.txt`

Add or edit a secret:

```bash
sops secrets/<file>.yaml

# after changing recipients in .sops.yaml, rekey the file
sops updatekeys secrets/<file>.yaml
```

Reference it in a machine config (every secret must set `sopsFile` explicitly):

```nix
sops.secrets.mySecret = {
  sopsFile = ../../secrets/<file>.yaml;
  key = "my_secret_key";
};
```

## Other commands

- List all generations.

```bash
nixos-rebuild list-generations
```

## License

This project is licensed under [MIT License](./LICENSE).
