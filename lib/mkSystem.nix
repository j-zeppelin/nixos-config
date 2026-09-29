{inputs}: {
  hostname,
  system,
  theme,
  extraModules ? [],
}:
inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = {inherit inputs theme hostname;};

  modules =
    [
      inputs.sops-nix.nixosModules.sops
      ../hosts/${hostname}
      ../modules/nixos/common.nix
    ]
    ++ extraModules;
}
