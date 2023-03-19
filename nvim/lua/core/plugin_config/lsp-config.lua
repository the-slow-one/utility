require('mason').setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

local lsp_servers = {
  'lua_ls',
  'clangd',
  'cmake',
  'grammarly',
  'html',
  'marksman',
  'pyright',
  'rust_analyzer',
}


require('mason-lspconfig').setup({
  ensure_installed = lsp_servers,
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    },
  },
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader><space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader><space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader><space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader><space>f',
    function() vim.lsp.buf.format {
      async = true
    } end, bufopts
  )
end

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local skip_server_setup = {'clangd', 'rust_analyzer'}

local function has_value (tab, val)
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end
  return false
end

for _, lsp_server in ipairs(lsp_servers) do
  if not has_value(skip_server_setup, lsp_server) then
    lspconfig[lsp_server].setup {
      on_attach = on_attach,
      capabilites = capabilities,
    }
  end
end

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        -- For some reason `vim` is not recognised by lua_ls in modules
        globals = {'vim'},
      },
    },
  },
}
