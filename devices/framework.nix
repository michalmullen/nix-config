/*
framework 13 laptop
*/

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ../nixos/desktop.nix
    ../nixos/filesystem.nix
    # ../nixos/nix.nix
    # ../nixos/sshd.nix
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

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];


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

  system.stateVersion = "24.05";

  home-manager.users.michalmullen = {
    imports = [
      ../home/home.nix
      ../home/shell.nix
    ];
    home.stateVersion = "24.05";
  };
}