{
  pkgs,
  inputs,
  ...
}: let
  devinit = pkgs.writeShellScriptBin "devinit" ''
    git init
    devenv init

    cat > .envrc <<'EOF'
    eval "$(devenv direnvrc)"
    use devenv
    EOF

    direnv allow
  '';
in {
  home.packages = with pkgs; [
    devinit
    cloc
    findutils
    unzip
    pciutils
    killall
    fastfetch
    gdu
    xdg-utils
    wl-clipboard
    eza
    devenv
    brightnessctl
    tree
    file
    inputs.systemd-manager-tui.packages.x86_64-linux.default
    ffmpeg-full
    yt-dlp
  ];

  home.shellAliases = {
    cd = "z";
    cat = "bat";
    shit = "shutdown";
    ls = "eza --color=always --group-directories-first --icons always";
    lsa = "eza --color=always --all --group-directories-first --long --icons always --no-permissions --git";
    lg = "lazygit";
    xo = "xdg-open";
    n = "nvim";
    e = "exit";
    ga = "git add";
    gc = "git commit";
    gs = "git status";
    gp = "git push";
    gpl = "git pull";
    hms = "nh home switch";
    nos = "nh os switch";
    ff = "fastfetch";
    stm = "systemd-manager-tui";
  };

  programs = {
    bat.enable = true;
    btop.enable = true;
    television.enable = true;
    zoxide.enable = true;
    ripgrep.enable = true;
    jq.enable = true;

    fd = {
      enable = true;
      hidden = true;
    };

    fzf = {
      enable = true;
      historyWidget.command = "";
    };

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/jzep/.dotfiles";
    };

    atuin = {
      enable = true;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://api.atuin.sh";
        search_mode = "prefix";
        keymap_mode = "vim-normal";
        keymap_cursor = {
          emacs = "blink-block";
          vim_insert = "blink-bar";
          vim_normal = "steady-block";
        };
      };
    };
  };
}
