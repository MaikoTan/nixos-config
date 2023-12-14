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

```bash
nixos-rebuild switch --experimental-features 'nix-command flakes' --flake ".#<hostname>"
```

- Reboot your system.

```bash
reboot
```

## License

This project is licensed under [CC-BY-SA-4.0](https://creativecommons.org/licenses/by-sa/4.0/) license.

![CC-BY-SA-4.0](https://mirrors.creativecommons.org/presskit/buttons/88x31/svg/by-sa.svg)
