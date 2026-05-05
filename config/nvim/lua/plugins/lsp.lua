-- lsp.lua
-- Requires Neovim >= 0.11 (uses built-in vim.lsp.config / vim.lsp.enable API)
-- Compatible with Lazy.nvim — zero external dependencies
-- Supports: C++ (clangd), Python (pyright)
--
-- Install language servers manually before use:
--   C++:    brew install llvm        OR  apt install clangd
--   Python: pip install pyright      OR  npm install -g pyright

return {
  {
    -- Virtual plugin: no remote repo, just a Lazy hook to run config()
    "lsp-setup",
    dir = vim.fn.stdpath("config"), -- points at your nvim config dir; satisfies Lazy's dir requirement
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- ------------------------------------------------------------------ --
      --  vim.lsp.config()  – declare server settings  (Neovim 0.11+)      --
      --  vim.lsp.enable()  – activate servers                              --
      -- ------------------------------------------------------------------ --

      -- Shared on_attach: keymaps applied to every LSP buffer
      local function on_attach(_, bufnr)
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
        end
        map("gd",         vim.lsp.buf.definition,  "LSP: Go to definition")
        map("gr",         vim.lsp.buf.references,  "LSP: List references")
        map("K",          vim.lsp.buf.hover,       "LSP: Hover docs")
        map("<leader>rn", vim.lsp.buf.rename,      "LSP: Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
        map("<leader>f",  function()
          vim.lsp.buf.format({ async = true })
        end, "Format buffer")
      end

      -- ── clangd (C / C++) ────────────────────────────────────────────── --
      vim.lsp.config("clangd", {
        cmd = { "clangd" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_markers = {
          "compile_commands.json",
          "compile_flags.txt",
          ".git",
        },
        on_attach = on_attach,
      })

      -- ── pyright (Python) ────────────────────────────────────────────── --
      vim.lsp.config("pyright", {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = {
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          ".git",
        },
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
            },
          },
        },
        on_attach = on_attach,
      })

      -- Activate both servers
      vim.lsp.enable({ "clangd", "pyright" })
    end,
  },
}
