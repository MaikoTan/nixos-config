# nixos-config

My own NixOS configurations

## Installation

- Clone this repository to any location you want.

```bash
git clone https://github.com/MaikoTan/nixos-config.git /usr/nixos-config
```

- [Create partitions for NixOS](https://nixos.org/manual/nixos/stable/#sec-installation-manual-partitioning) if you haven't done so.

- Run the following command to install NixOS.

```bash
nixos-install --option experimental-features 'nix-command flakes' --flake "/usr/nixos-config#<hostname>"
```

- If you are not using first-time installation, run the following command to switch to the new configuration.
    - If you encounter network issues, you may also try the mirror with option `--mirror`.

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

If you have changed anything managed by `dconf`, make sure to run the following command (in fish shell) to update the `dconf` config.

```bash
./build.fish
```

## License

This project is licensed under [MIT License](./LICENSE).
