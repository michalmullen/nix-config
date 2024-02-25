{ config, inputs, ... }:

{
  imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

  home.persistence."/persist/home/" = {
    directories = [
      "download"  # persistent downloads
      "repos"  # all Git projects
      "data"  # local general data, pictures, screenshots, backups, …
      ".ssh"  # TODO secret management? known_hosts into config?
      ".config/vivaldi" ".local/lib/vivaldi"
      ".mozilla"  # Firefox
      ".local/share/systemd"  # various state for systemd such as persistent timers
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
      ".cache"  # is persisted, but kept clean with systemd-tmpfiles, see below
    ];
    files = [
      ".bash_history"
    ];
    allowOther = true;
  };
}
