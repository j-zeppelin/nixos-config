{config, ...}: {
  imports = [
    ./cli.nix
    ./shell/fish.nix
    ./git.nix
    ./yazi.nix
    ./app/common-apps.nix
  ];

  config = {
    _module.args.link = config.lib.file.mkOutOfStoreSymlink;
    fonts.fontconfig.enable = true;

    home.sessionVariables = {
      PROTON_PASS_KEY_PROVIDER = "fs";
      QT_QPA_PLATFORM = "wayland";
    };

    home.sessionPath = [
      "$HOME/.local/bin"
      "$HOME/bin"
      "$HOME/.nix-profile/bin"
      "$HOME/.nix-profile/share/applications"
    ];
    home.pointerCursor.enable = true;

    services = {
      protonmail-bridge.enable = true;
    };

    nixpkgs.config.allowUnfree = true;

    programs.home-manager.enable = true;
  };
}
