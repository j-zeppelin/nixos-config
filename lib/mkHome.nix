{inputs}: {
  username,
  system,
  profile,
  theme,
}:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  extraSpecialArgs = {inherit inputs theme profile;};

  modules = [
    ../home/${profile}.nix
    ../modules/home/common.nix
    inputs.sops-nix.homeManagerModules.sops
    {
      home.username = username;
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "26.05";
      home.pointerCursor.enable = true;
    }
  ];
}
