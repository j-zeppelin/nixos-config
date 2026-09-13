{
  pkgs,
  inputs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  boot = {
    plymouth = {
      enable = false;
    };

    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_zen;

    loader.systemd-boot.enable = lib.mkForce false;
    supportedFilesystems = ["ntfs"];
    kernelModules = ["btusb"];

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
