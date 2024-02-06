/*
miranda: my notebook

Lenovo ThinkPad Yoga 460
*/

{ pkgs, ... }:

{
  imports = [
    ../nixos/desktop.nix
    ../nixos/filesystems.nix
    ../nixos/nix.nix
    ../nixos/sshd.nix
    ../nixos/users.nix
  ];

  # use systemd-boot as bootloader
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 12;  # maximum number of latest NixOS generations to show
    };
    efi.canTouchEfiVariables = true;
  };

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."luks-1e1c7339-e378-448a-ac29-0b01ed47beaf".device = "/dev/disk/by-uuid/1e1c7339-e378-448a-ac29-0b01ed47beaf";

  programs.light.enable = true;  # for backlight control

  networking.hostName = "framework";

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  system.stateVersion = "22.11";

  home-manager.users.michalmullen = {
    imports = [
      ../home/base.nix
      ../home/shell.nix
    ];
    michalmullen = {
      deviceColor = "#640060";  # violet
    #   displays = {
    #     main = {
    #       id = "BOE 0x0637";
    #       posX = 0;
    #       posY = 0;
    #       width = 1920;
    #       height = 1080;
    #     };
    #     secondary = null;
    #     auxiliary = [
    #       {
    #         id = "HDMI-A-2";
    #         posX = 1920;
    #         posY = 0;
    #       }
    #     ];
    #   };
    };
    deploymentType = "nixos";
    home.stateVersion = "22.11";
  };
}