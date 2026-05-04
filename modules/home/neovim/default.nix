{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = false;
    withPython3 = true;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [
      # Search and navigation.
      plenary-nvim
      telescope-nvim

      # LSP and Rust.
      nvim-lspconfig
      rustaceanvim

      # Completion.
      blink-cmp

      # Syntax tree parsing.
      nvim-treesitter

      # Quality of life.
      gitsigns-nvim
      which-key-nvim
      lualine-nvim
      nvim-web-devicons
      tokyonight-nvim
      conform-nvim
      crates-nvim
    ];

    initLua = ''
      ${builtins.readFile ./lua/base.lua}
      ${builtins.readFile ./lua/plugins.lua}
      ${builtins.readFile ./lua/keymaps.lua}
    '';
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    nil
    lua-language-server
  ];
}