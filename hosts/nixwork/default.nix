{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/podman.nix
    ../../modules/nixos/de/niri.nix
    ../../modules/nixos/boot/systemd-boot.nix
    ../../modules/nixos/de/niri.nix
    ../../modules/nixos/stylix.nix
    ./vpn.nix
  ];

  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };

  services = {
    fprintd.enable = true;
    power-profiles-daemon.enable = true;

    upower = {
      enable = true;
      percentageLow = 20;
    };
  };

  networking.firewall = {
    enable = true;
  };
}
