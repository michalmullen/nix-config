/*
https://github.com/nix-community/impermanence?tab=readme-ov-file
*/

{ pkgs, lib, config, inputs, ... }:

{
  # use impermanence for root on tmpfs
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options = {
    michalmullen.encryption = lib.mkOption {
      description = "Whether to enable device encryption.";
      default = true;
      type = lib.types.bool;
    };
  };

  config = {
    # regularly run TRIM
    services.fstrim.enable = true;

    # enable udisks2, required for automounting with udiskie
    services.udisks2.enable = true;

    # automatically scrub the main filesystem
    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/mnt/main" ];
    };

    # decrypt the main device with LUKS
    boot.initrd.luks.devices = lib.mkIf config.michalmullen.encryption {
      "main" = {
        device = "/dev/disk/by-partlabel/main";
        # allow SSD TRIM commands (note that this is a security tradeoff)
        allowDiscards = true;
      };
    };

    /*
    use a separate tmpfs for /tmp
    NixOS uses tmpfiles.d by systemd by default to remove tmpfiles after a set time
    but as I have root on tmpfs anyway, there's not really any sense in that
    a separate tmpfs for /tmp then helps separating important state changes from /tmp
    */
    boot.tmp.useTmpfs = true;

    {
        fileSystems."/" = {
            device = "/dev/root_vg/root";
            fsType = "btrfs";
            options = [ "subvol=root" ];
        };

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

        fileSystems."/persistent" = {
            device = "/dev/root_vg/root";
            neededForBoot = true;
            fsType = "btrfs";
            options = [ "subvol=persistent" ];
        };

        fileSystems."/nix" = {
            device = "/dev/root_vg/root";
            fsType = "btrfs";
            options = [ "subvol=nix" ];
        };

        fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/XXXX-XXXX";
            fsType = "vfat";
        };
    };

    # can be created with btrfs mkswapfile
    #  swapDevices = [ { device = "/swap/swapfile"; } ];

    # configure persistent directories
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/log"  # system logs
        "/var/lib/systemd"  # various state for systemd such as persistent timers
        "/var/lib/nixos"
        # "/var/lib/docker"  # TODO: remove once I got rid of Docker on sapphire
        /*
        /var/tmp is expected to be on disk and have enough free space
        e.g. by podman when copying images, which will easily fill up the tmpfs

        so we persist this and add a systemd-tmpfiles rule below to clean it up
        on a schedule
        */
        "/var/tmp"
        "/var/lib/bluetooth"  # bluetooth connection state stuff
        "/var/lib/microvms"  # MicroVMs
      ];
    #   files = [
    #     # SSH host keys for secrets with agenix and sshd
    #     "/etc/ssh/ssh_host_ed25519_key" "/etc/ssh/ssh_host_ed25519_key.pub"
    #   ];
    };

    # # /var/tmp is persisted for reasons explained above, clean it with systemd-tmpfiles
    # systemd.tmpfiles.rules = [ "e /var/tmp 1777 root root 30d" ];

    # allows other users to access FUSE mounts
    # necessary for allowOther in home.persistence
    #  programs.fuse.userAllowOther = true;
  }
}
