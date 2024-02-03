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

  programs.light.enable = true;  # for backlight control

  networking.hostName = "framework";

  system.stateVersion = "22.11";

  home-manager.users.michalmullen = {
    imports = [
      ../home/base.nix
      ../home/shell.nix
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