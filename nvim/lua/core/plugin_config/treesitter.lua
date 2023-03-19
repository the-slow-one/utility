require'nvim-treesitter.configs'.setup {
  -- A list of parser names. We can also use "all"
  ensure_installed = { "c", "cpp", "lua", "rust", "python", "vim" },
  -- Install parsers synchronusly (only applies to `ensure_installed`
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true
  },
}
