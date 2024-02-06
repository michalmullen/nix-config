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

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualization.virtualbox.guest.enable = true;


  programs.light.enable = true;  # for backlight control

  networking.hostName = "vm";

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