# NixOS Flake Configuration

## Overview

A personal Nix flake providing NixOS and integrated Home Manager configurations for supported devices.

Supported devices:

- **Dell XPS 13 7390** — `x86_64-linux`, configuration: `xps13`.
- **AZW GTi13-Ultra** — Intel Core i9-13900HK, `x86_64-linux`, configuration: `gti13-ultra`.

## Quick Start

Use an existing NixOS installation with the `nix-command` and `flakes` experimental features enabled. Run the following commands from the repository root.

Inspect the flake outputs and validate the configuration using the pinned dependencies:

```sh
nix flake show --no-update-lock-file
nix flake check --no-build --no-update-lock-file
```

[`nix flake show`](https://nix.dev/manual/nix/latest/command-ref/new-cli/nix3-flake-show) lists the available outputs. [`nix flake check --no-build`](https://nix.dev/manual/nix/latest/command-ref/new-cli/nix3-flake-check) validates the flake outputs without building checks; it does not build the full system.

Choose a configuration name from the flake outputs, replacing `<host>` below. Build and activate the system and Home Manager configuration:

```sh
sudo nixos-rebuild switch --flake '.#<host>' --no-update-lock-file
```
