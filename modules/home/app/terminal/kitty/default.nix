{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    nerd-fonts.iosevka-term
    maple-mono.NF
  ];

  home.sessionVariables = {
    TERM_CMD = "kitty";
  };

  home.file.".config/kitty/neighboring_window.py" = {
    source = "${pkgs.vimPlugins.smart-splits-nvim}/kitty/neighboring_window.py";
    executable = true;
  };
  home.file.".config/kitty/relative_resize.py" = {
    source = "${pkgs.vimPlugins.smart-splits-nvim}/kitty/relative_resize.py";
    executable = true;
  };
  home.file.".config/kitty/split_window.py" = {
    source = "${pkgs.vimPlugins.smart-splits-nvim}/kitty/split_window.py";
    executable = true;
  };

  # home.file.".config/kitty/relative_resize.py".text = builtins.readFile ./relative_resize.py;
  # home.file.".config/kitty/split_window.py".text = builtins.readFile ./split_window.py;
  # home.file.".config/kitty/neighboring_window.py".text = builtins.readFile ./neighboring_window.py;

  programs.kitty = {
    enable = true;
    font = {
      name = lib.mkForce "IosevkaTerm Nerd Font";
    };
    enableGitIntegration = true;
    shellIntegration.enableFishIntegration = true;

    keybindings = {
      "ctrl+j" = "neighboring_window down";
      "ctrl+k" = "neighboring_window up";
      "ctrl+h" = "neighboring_window left";
      "ctrl+l" = "neighboring_window right";

      "alt+j" = "kitten relative_resize.py down 3";
      "alt+k" = "kitten relative_resize.py up 3";
      "alt+h" = "kitten relative_resize.py left 3";
      "alt+l" = "kitten relative_resize.py right 3";

      "ctrl+space>enter" = "new_tab_with_cwd";
      "ctrl+space>e" = "close_window";
      "ctrl+space>h" = "launch --location=hsplit --cwd=current";
      "ctrl+space>v" = "launch --location=vsplit --cwd=current";

      "ctrl+space>1" = "goto_tab 1";
      "ctrl+space>2" = "goto_tab 2";
      "ctrl+space>3" = "goto_tab 3";
      "ctrl+space>4" = "goto_tab 4";
      "ctrl+space>5" = "goto_tab 5";
      "ctrl+space>6" = "goto_tab 6";
      "ctrl+space>7" = "goto_tab 7";
      "ctrl+space>8" = "goto_tab 8";
      "ctrl+space>9" = "goto_tab 9";

      "ctrl+space>s" = "goto_session";
    };

    settings = {
      shell = "fish";
      enabled_layouts = "splits";
      scrollback_lines = 80000;
      modify_font = "cell_width 100%";
      window_padding_width = 5;

      tab_bar_edge = "top";
      tab_bar_margin_width = 2;
      tab_bar_style = "separator";
      tab_separator = " |";
      tab_title_max_length = 10;
      tab_title_template = "{index}:{title}";

      confirm_os_window_close = 0;
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/mykitty";

      cursor_trail = 1;
    };

    extraConfig = ''
      map --when-focus-on var:IS_NVIM ctrl+j
      map --when-focus-on var:IS_NVIM ctrl+k
      map --when-focus-on var:IS_NVIM ctrl+h
      map --when-focus-on var:IS_NVIM ctrl+l

      map --when-focus-on var:IS_NVIM alt+j
      map --when-focus-on var:IS_NVIM alt+k
      map --when-focus-on var:IS_NVIM alt+h
      map --when-focus-on var:IS_NVIM alt+l

    '';
  };
}
