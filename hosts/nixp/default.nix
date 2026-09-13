{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/stylix.nix
    ../../modules/nixos/ollama.nix
    ../../modules/nixos/podman.nix
    ../../modules/nixos/de/niri.nix
    ../../modules/nixos/virtualization.nix
    ../../modules/nixos/boot/lanzaboote.nix
    ../../modules/nixos/de/niri.nix
    ../../modules/nixos/gpu-screen-recorder.nix
  ];

  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  environment.systemPackages = with pkgs; [
    ntfs3g
    sbctl
    android-tools
    ddcutil
  ];

  # fileSystems."/mnt/nvme0" = {
  #   neededForBoot = false;
  #   device = "/dev/disk/by-uuid/8A7AECD97AECC355";
  #   fsType = "ntfs";
  #   options = [
  #     "uid=1000"
  #     "gid=100"
  #     "rw"
  #     "user"
  #     "exec"
  #     "umask=000"
  #   ];
  # };

  fileSystems."/mnt/nvme1" = {
    neededForBoot = false;
    device = "/dev/disk/by-uuid/30e54746-6d5e-4100-96f7-ab01d56edf92";
    fsType = "ext4";
  };

  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope.overrideAttrs (_: {
      NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
    });
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    extraPackages = with pkgs; [
      libXcursor
      libXi
      libXinerama
      libXScrnSaver
      libpng
      libpulseaudio
      libvorbis
      stdenv.cc.cc.lib
      libkrb5
      keyutils
    ];
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu.initrd.enable = true;
    i2c.enable = true;
  };

  boot.kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-lts-zen4;

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [cnijfilter2];
    };

    greetd.settings = {
      initial_session = {
        command = "niri-session";
        user = "jzep";
      };
    };
  };
}
