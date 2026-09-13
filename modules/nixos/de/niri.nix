{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];
  nixpkgs.overlays = [
    (final: prev: {
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

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  programs = {
    niri = {
      enable = true;
      package = pkgs.niri;
    };
    gnome-disks.enable = true;
  };

  security = {
    polkit.enable = true;
    pam.services.greetd.enableGnomeKeyring = true;
  };

  programs.noctalia-greeter = {
    enable = true;
    package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  services = {
    gnome.gnome-keyring.enable = true;
    # greetd = {
    #   enable = true;
    #   useTextGreeter = true;
    #   settings = {
    #     default_session = {
    #       command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
    #       user = "greeter";
    #     };
    #   };
    # };
  };
}
