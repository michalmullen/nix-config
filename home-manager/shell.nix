/*
shell applications
*/

{ inputs, inputs', self', pkgs, lib, res, config, ... }:

{
  home.packages = [
    pkgs.pandoc  # universal document converter
    pkgs.imagemagick  # image converter etc.

    # tools
    pkgs.nano  # simple file editor for quick edits
    pkgs.curl  # download files etc.
    pkgs.qrtool  # generate QR codes from command line
    pkgs.fd  # better find
    pkgs.ripgrep  # better grep
    pkgs.du-dust  # better du, show size of directories as a tree
    pkgs.duf  # better df, show devices and their usage
    pkgs.bat  # better cat
    pkgs.tree  # show filesystem trees
    pkgs.broot  # traverse filesystem trees
    pkgs.file  # identify file types
    pkgs.killall  # kill processes by name
    pkgs.dogdns  # DNS querying tool
    pkgs.edir  # renaming tool
    pkgs.ouch  # general archive tool that supports various formats
    pkgs.unzip  # extract zip archives
    pkgs.nix-tree  # explore dependencies of Nix derivations
    pkgs.gojq  # JSON processor, like jq, but in Go and compatible with YAML
    pkgs.jqp  # jq playground
    pkgs.age  # encryption tool
    pkgs.parallel  # execute commands in parallel
    pkgs.e2fsprogs  # ext2/3/4 tools, and also chattr
    pkgs.openssl  # useful for secret generation etc
    pkgs.swaks  # useful tool for email and SMTP testing

    # devops
    pkgs.kubectl
    pkgs.k9s
    pkgs.terraform

    # system management
    pkgs.neofetch
    pkgs.bottom  # better htop, system monitor
    pkgs.glances  # also better htop, system monitor
    pkgs.pciutils  # for lspci
    pkgs.gptfdisk  # formatting tool for GPT disks
    pkgs.clinfo  # info tool for OpenCL
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Mitchell Mullen";
    userEmail = "michalmullen@proton.me";
    aliases = {
      yeet = "push --force-with-lease";
    };
    difftastic.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      merge.conflictStyle = "diff3";
    };
  };
}

