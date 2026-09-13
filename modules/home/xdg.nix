{pkgs, ...}: {
  xdg = {
    autostart.enable = true;
    configFile."electron-flags.conf".text = ''
      --ozone-platform=wayland
      --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer
    '';

    desktopEntries = {
      btop = {
        name = "btop++";
        noDisplay = true;
      };
      fish = {
        name = "fish";
        noDisplay = true;
      };
      vim = {
        name = "Vim";
        noDisplay = true;
      };
      gvim = {
        name = "GVim";
        noDisplay = true;
      };
      nvim = {
        name = "nvim";
        noDisplay = true;
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
      templates = null;
      desktop = null;
      projects = null;
      publicShare = null;
    };

    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
        xdg-desktop-portal-termfilechooser
      ];

      config = {
        common = {
          default = "gnome";
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
          "org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
        };
      };
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura.desktop";
        "text/html" = "firefox.desktop";
        "inode/directory" = "yazi.desktop";
        "video/mp4" = "mpv.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";

        "image/png" = "org.gnome.eog.desktop";
        "image/jpeg" = "org.gnome.eog.desktop";
        "image/webp" = "org.gnome.eog.desktop";
        "image/gif" = "org.gnome.eog.desktop";
      };
    };
  };
}
