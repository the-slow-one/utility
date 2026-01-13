local lua_lsp_settings = {
  Lua = {
    runtime = {
      -- Tell the language server which version of Lua you're using
      -- (most likely LuaJIT in the case of Neovim)
      version = 'LuaJIT',
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global
      globals = {
        'vim',
        'require'
      },
    },
    workspace = {
      -- Make the server aware of Neovim runtime files
      library = vim.api.nvim_get_runtime_file("", true),
    },
    -- Do not send telemetry data containing a randomized but unique identifier
    telemetry = {
      enable = false,
    },
  },
}

local function get_lang_server_details()
  -- install an LSP using brew and list it here
  return {
    -- lsp with specific config
    -- lua_ls = { settings = lua_lsp_settings },
    clangd = {
        cmd = { '/home/deepakhr/bin/clangd' },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
        root_markers = {
            '.clangd',
            '.clang-tidy',
            '.clang-format',
            'compile_commands.json',
            'compile_flags.txt',
            'configure.ac', -- AutoTools
            '.git',
        },
        capabilities = {
            textDocument = {
                completion = {
                    editsNearCursor = true,
                },
            },
            offsetEncoding = { 'utf-8', 'utf-16' },
        },
    },
    -- lsp with generic config (includes auto-complete ability)
    pyright = {},
  }
end

-- SetupLangServers is called in lspconfig.config()
function SetupLangServers(lspconfig)
  local lsp_autocmp_capabilites = require("cmp_nvim_lsp").default_capabilities()

  for server, config in pairs(get_lang_server_details()) do
    -- Autocomplete capabilities are added to all servers by default
    config.capabilities = lsp_autocmp_capabilites
    lspconfig[server] = config
  end
end

return {}
