
{ pkgs, lib, inputs, ... }:
{
  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # install kitty's terminfo system-wide (additionally to in home) so that `sudo -s` works via SSH
  environment.systemPackages = [ pkgs.kitty.terminfo ];
  programs = {
    /*
    Declared on the NixOS level instead home-manager because it needs some capabilities set.
    See: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/mtr.nix
    */
    mtr.enable = true;  # a better traceroute
    # enable git globally, config is on home level
    git = {
      enable = true;
      lfs.enable = true;
    };
  };

    /*
  systemd OOM killer (is on by default, but not on any slices)

  for enabled slices see:
  https://github.com/NixOS/nixpkgs/blob/ef0bc3976340dab9a4e087a0bcff661a8b2e87f3/nixos/modules/system/boot/systemd/oomd.nix#L10C7-L10C95
  */
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableUserServices = true;
  };

  # use systemd on initrd
  boot.initrd.systemd.enable = true;

  # enable fwupd deamon
  services.fwupd.enable = true;

}