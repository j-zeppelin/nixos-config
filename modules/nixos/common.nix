{
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ./pipewire.nix
    ./services.nix
    ./sops.nix
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "jzep"
      ];
    };
    package = pkgs.lixPackageSets.stable.lix;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [
      (final: prev: {
        inherit
          (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena
          ;
      })
    ];
  };

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  networking = {
    hostName = hostname;
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openconnect
      ];
    };
  };

  users.users.jzep = {
    isNormalUser = true;
    description = "jzep";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "docker"
      "video"
      "i2c"
      "input"
    ];
    shell = pkgs.fish;
  };

  programs = {
    fish.enable = true;
    nix-ld = {
      enable = true;
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      git
      vim
      networkmanagerapplet
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  system.stateVersion = "26.05";
}
