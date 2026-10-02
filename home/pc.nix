{
  pkgs,
  lib,
  inputs,
  system,
  ...
}: let
  krisp-patcher =
    pkgs.writers.writePython3Bin "krisp-patcher"
    {
      libraries = with pkgs.python3Packages; [
        capstone
        pyelftools
      ];
      flakeIgnore = [
        "E501" # line too long (82 > 79 characters)
        "F403" # 'from module import *' used; unable to detect undefined names
        "F405" # name may be undefined, or defined from star imports: module
      ];
    }
    (
      builtins.readFile (
        pkgs.fetchurl {
          url = "https://pastebin.com/raw/8tQDsMVd";
          sha256 = "sha256-IdXv0MfRG1/1pAAwHLS2+1NESFEz2uXrbSdvU9OvdJ8=";
        }
      )
    );
in {
  imports = [
    ../modules/home/git.nix
    ../modules/home/distrobox.nix
    ../modules/home/stylix.nix
    ../modules/home/xdg.nix

    ../modules/home/de/niri
    ../modules/home/de/shell/noctalia

    ../modules/home/app/browser/firefox.nix
    ../modules/home/app/terminal/kitty
    ../modules/home/app/neovim
    ../modules/home/app/spotify.nix
    ../modules/home/app/jetbrains.nix
    ../modules/home/sops.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };

      xwayland-satellite = prev.xwayland-satellite.overrideAttrs (old: rec {
        version = "0.8.1";

        src = final.fetchFromGitHub {
          owner = "Supreeeme";
          repo = "xwayland-satellite";
          rev = "536bd32";
          hash = "sha256-BUE41HjLIGPjq3U8VXPjf8asH8GaMI7FYdgrIHKFMXA=";
        };

        cargoDeps = final.rustPlatform.fetchCargoVendor {
          inherit (old) pname;
          inherit version src;
          hash = "sha256-16L6gsvze+m7XCJlOA1lsPNELE3D364ef2FTdkh0rVY=";
        };
      });
    })
  ];

  home.packages = [
    pkgs.prismlauncher
    pkgs.eden
    pkgs.rpi-imager
    pkgs.me3
    pkgs.mangohud

    pkgs.proton-vpn
    pkgs.signal-desktop
    pkgs.qbittorrent
    pkgs.osu-lazer-bin
    pkgs.filezilla
    pkgs.wine
    pkgs.winetricks
    pkgs.bottles
    pkgs.vesktop

    krisp-patcher
  ];

  stylix.fonts.sizes.terminal = lib.mkForce 13.5;
  home.file.".local/share/Steam/compatibilitytools.d/Proton-GE".source = pkgs.proton-ge-bin.steamcompattool;
}
