/*
configuration for nixpkgs
*/

{ inputs, system, pkgs, config, lib, ... }:

{

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
  
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };


  nixpkgs = {
    hostPlatform = system;
    config = {
      # e.g. required for Vivaldi
      allowUnfree = true;
    #   permittedInsecurePackages = [
    #     "dcraw-9.28.0"
    #   ];
    };
    overlays = [
      inputs.self.overlays.unstable
    ];
  };
}
