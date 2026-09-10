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

- `flake.nix` — Flake entry: machine definitions, overlays, devShell
- `machines/<hostname>/` — Machine-specific configs (`config.nix` + generated
  `hardware.nix`)
- `profiles/` — Composition layer: which modules to enable per machine type
- `modules/` — Reusable NixOS modules (option + config pattern, enabled via
  `maiko.*` options)
- `modules/home-manager/` — User-level configuration (fish, vscode, dconf,
  plasma)
- `secrets/` — SOPS-encrypted secrets (age)

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
