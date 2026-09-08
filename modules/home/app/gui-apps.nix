{pkgs, ...}: {
  home.packages = with pkgs; [
    proton-vpn
    # libreoffice-fresh
    signal-desktop
    qbittorrent
    osu-lazer-bin
    filezilla
    # wine
    # winetricks
    vesktop
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
