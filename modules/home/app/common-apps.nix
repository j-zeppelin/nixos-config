{pkgs, ...}: {
  home.packages = with pkgs; [
    nix-update
  ];

  programs = {
    zathura.enable = true;
    chromium.enable = true;
    obsidian.enable = true;
    mpv.enable = true;
    thunderbird = {
      enable = true;
      profiles = {};
    };
  };
}
