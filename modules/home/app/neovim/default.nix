{
  pkgs,
  theme,
  config,
  link,
  ...
}: let
  nvimDir = "${config.home.homeDirectory}/.dotfiles/modules/home/app/neovim";
in {
  imports = [
    ../../yazi.nix
  ];

  home.packages = with pkgs; [
    lua-language-server
    ty
    bash-language-server
    nil

    stdenv.cc
    prettier
    prettierd
    stylua
    alejandra
    ruff
    tree-sitter
    neovim
  ];

  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.NVIM_THEME = theme;

  home.file = {
    ".config/nvim" = {
      source = link "${nvimDir}/lazy";
      recursive = true;
    };
  };
}
