return {
  "neovim/nvim-lspconfig",
  config = function()
    require("nvim-treesitter").setup({})
    vim.lsp.enable("clangd")
  end
}
