function load_clangd_extns()
  require("clangd_extensions").setup({})
  require("clangd_extensions.inlay_hints").setup_autocmd()
  require("clangd_extensions.inlay_hints").set_inlay_hints()
end

return {{
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/nvim-cmp",
  },

  config = function()
    require("nvim-treesitter").setup({})

    -- install an LSP using brew and call setup here
    local lspconfig = require("lspconfig")

    lspconfig.lua_ls.setup({})

    lspconfig.clangd.setup({
      on_attach = load_clangd_extns
    })

    lspconfig.pyright.setup({})
  end
}}
