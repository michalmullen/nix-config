{ config, inputs, ... }:

{
  imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

  home.persistence."/persist/home/michalmullen" = {
    directories = [
      "download"  # persistent downloads
      "repos"  # all Git projects
      "data"  # local general data, pictures, screenshots, backups, …
      ".ssh"  # TODO secret management? known_hosts into config?
      ".config/vivaldi" ".local/lib/vivaldi"
      ".mozilla"  # Firefox
      ".local/share/systemd"  # various state for systemd such as persistent timers
      {
        directory = ".local/share/containers";
        method = "symlink";
      }
      ".cache"  # is persisted, but kept clean with systemd-tmpfiles, see below
    ];
    files = [
      ".bash_history"
    ];
    allowOther = true;
  };

#   systemd.user.tmpfiles.rules = [
#     /*
#     clean old contents in home cache dir
#     (it's persisted to avoid problems with large files being loaded into the tmpfs)
#     */
#     "e %h/.cache 755 ${config.home.username} ${config.home.groupname} 30d"

#     # exceptions
#     "x %h/.cache/rbw"
#     "x %h/.cache/borg"  # caches checksums of file chunks for deduplication
#   ];
}
