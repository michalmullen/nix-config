# nix-config

My personal nix configuration for my devices.
Mostly inspired by https://git.eisfunke.com/config/nixos/

## How to partition disk

replace '"/dev/vda"' with your drive using `lsblk`
```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /home/disks.nix --arg device '"/dev/vda"'
```

## How to install/update

```bash
nixos-install --no-root-password --root /mnt --flake flake.nix#framework
```
