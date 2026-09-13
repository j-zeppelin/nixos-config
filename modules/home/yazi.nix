{pkgs, ...}: {
  home.file.".config/xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
    default_dir=$HOME
    env=TERM_CMD=kitty
    env=PATH="$PATH:/run/current-system/sw/bin"
    open_mode = suggested
    save_mode = last
  '';

  xdg = {
    desktopEntries.yazi = {
      name = "Yazi";
      genericName = "File Manager";
      exec = "kitty -e yazi %U";
      terminal = false;
      type = "Application";
      mimeType = ["inode/directory"];
      categories = ["System" "FileManager"];
    };

    portal = {
      enable = true;
      config = {
        common = {
          "org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
        };
      };
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "yazi.desktop";
      };
    };
  };

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    plugins = {
      compress = pkgs.yaziPlugins.compress;
      toggle-pane = pkgs.yaziPlugins.toggle-pane;
      wl-clipboard = pkgs.yaziPlugins.wl-clipboard;
      mount = pkgs.yaziPlugins.mount;
    };
    settings = {
      mgr = {
        ratio = [0 4 2];
        linemode = "size";
      };

      opener = {
        pdf = [
          {
            run = "xdg-open %s1";
            orphan = true;
            desc = "Default PDF viewer";
          }
          {
            run = "firefox %s1";
            orphan = true;
            desc = "Firefox";
          }
        ];
      };

      open.prepend_rules = [
        {
          url = "*.pdf";
          use = ["pdf"];
        }
      ];
    };
    initLua = ''
      if os.getenv("NVIM") then
      	require("toggle-pane"):entry("min-preview")
      end
    '';
    keymap = {
      mgr.prepend_keymap = [
        {
          on = ["c" "a" "a"];
          run = "plugin compress";
          desc = "Archive selected files";
        }
        {
          on = ["c" "a" "p"];
          run = "plugin compress -p";
          desc = "Archive selected files (password)";
        }
        {
          on = ["c" "a" "h"];
          run = "plugin compress -ph";
          desc = "Archive selected files (password+header)";
        }
        {
          on = ["c" "a" "l"];
          run = "plugin compress -l";
          desc = "Archive selected files (compression level)";
        }
        {
          on = ["c" "a" "u"];
          run = "plugin compress -phl";
          desc = "Archive selected files (password+header+level)";
        }
        {
          on = "P";
          run = "plugin toggle-pane min-preview";
          desc = "Show or hide the preview pane";
        }
        {
          on = "<C-y>";
          run = ["plugin wl-clipboard"];
          desc = "Copy seleted items";
        }
        {
          on = "M";
          run = "plugin mount";
          desc = "Manage mounts";
        }
      ];
    };
  };
}
