/*
config for users and home-manager
*/

{ inputs, inputs', self', system, res, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  users = {
    mutableUsers = false;
    groups.users.gid = 100;
    users.michalmullen = {
      uid = 1000;
      description = "Mitchell Mullen";
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      initalPassword = "testpassword";

      # password can be hashed with: nix run nixpkgs#mkpasswd -- -m SHA-512 -s
      # hashedPassword = "$6$IrWnhWvp6BaCsfUD$h24blqdtDkyKzVoI7kDQH5KlkStrsRUAiNCzjGaqL5euHSAu4HYInI7ZwKFGKwm.UF1Ooo62GM0UctOP.CzLo1";
      # openssh.authorizedKeys.keys = builtins.attrValues (import (res + /ssh-user-keys.nix));
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs inputs' self' system res; };
    users.michalmullen.home.groupname = "users";
  };
}
