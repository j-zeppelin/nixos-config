{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../modules/home/git.nix
    ../modules/home/stylix.nix
    ../modules/home/xdg.nix

    ../modules/home/de/niri
    ../modules/home/de/shell/noctalia

    ../modules/home/app/browser/firefox.nix
    ../modules/home/app/terminal/kitty
    ../modules/home/app/neovim
    inputs.noctalia.homeModules.default
  ];

  home.packages = with pkgs; [
    rocketchat-desktop
    libreoffice-fresh
  ];

  programs.noctalia.settings = {
    bar.widgets = {
      scale = lib.mkForce 1.0;
    };
  };

  programs.atuin.enable = lib.mkForce false;
}
