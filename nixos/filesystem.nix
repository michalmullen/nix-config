/*
https://github.com/nix-community/impermanence?tab=readme-ov-file
*/

{ pkgs, lib, inputs, ... }:

{
  # use impermanence for root on tmpfs
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  # regularly run TRIM
  services.fstrim.enable = true;

  boot.initrd.postDeviceCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/root_vg/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
  '';

  # configure persistent directories
  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"  # system logs
      "/var/lib/systemd"  # various state for systemd such as persistent timers
      "/var/lib/nixos"
      # "/var/lib/docker"  # TODO: remove once I got rid of Docker on sapphire
      "/var/tmp"
      "/var/lib/bluetooth"  # bluetooth connection state stuff
    ];
  };

  # allows other users to access FUSE mounts
  # necessary for allowOther in home.persistence
  programs.fuse.userAllowOther = true;
}
