-- autocomplete.lua
-- Requires: Lazy.nvim, Neovim 0.11+
--
-- Features:
--   - Autocomplete from LSP via native vim.lsp APIs (no nvim-lspconfig)
--   - Autocomplete from current buffer words
--   - Tab / Shift-Tab to cycle through completion items
--   - Enter to confirm the highlighted selection

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",  -- bridges nvim-cmp ↔ native LSP client
      "hrsh7th/cmp-buffer",    -- current-buffer word completions
      "L3MON4D3/LuaSnip",      -- snippet engine (required by nvim-cmp)
      "saadparwaiz1/cmp_luasnip",
    },

    -- init() runs at plugin-load time, before any buffer events fire.
    -- We patch capabilities here so they are in place before vim.lsp.enable()
    -- is called by your lsp-setup plugin (which fires on BufReadPre/BufNewFile).
    init = function()
      -- ── Advertise enhanced capabilities to ALL native LSP servers ─────────
      --
      -- vim.lsp.config("*", ...) is the Neovim 0.11+ wildcard: settings here
      -- are merged into every server registered with vim.lsp.config() and
      -- activated via vim.lsp.enable() — exactly what your lsp.lua does.
      --
      -- Calling this before vim.lsp.enable() ensures clangd and pyright both
      -- receive the full nvim-cmp completion-item capability set, unlocking
      -- richer LSP completion responses (e.g. snippet placeholders, resolve).
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
    end,

    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      -- ── Helper: is there a non-whitespace character before the cursor? ─────
      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        if col == 0 then return false end
        local char = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col)
        return char:match("%s") == nil
      end

      -- ── nvim-cmp setup ────────────────────────────────────────────────────
      cmp.setup({

        -- Snippet expansion via LuaSnip
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        -- ── Key mappings ───────────────────────────────────────────────────
        mapping = cmp.mapping.preset.insert({

          -- Tab: open menu if closed; cycle forward if open;
          --      jump to next snippet placeholder if inside a snippet.
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback() -- insert a literal tab
            end
          end, { "i", "s" }),

          -- Shift-Tab: cycle backward; or jump to previous snippet placeholder.
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Enter: confirm the highlighted item.
          -- select = false means Enter inserts a newline when nothing is
          -- manually highlighted, preventing accidental confirmations.
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select   = false,
          }),

          -- Ctrl-Space: force-open the completion menu at any time.
          ["<C-Space>"] = cmp.mapping.complete(),

          -- Ctrl-e: close the menu without confirming.
          ["<C-e>"] = cmp.mapping.abort(),
        }),

        -- ── Sources (ordered by priority, grouped) ─────────────────────────
        sources = cmp.config.sources(
          -- Group 1 — shown first; falls through to group 2 only when empty.
          {
            { name = "nvim_lsp",  max_item_count = 20 },
            { name = "luasnip" },
          },
          -- Group 2 — buffer words as a fallback.
          {
            {
              name   = "buffer",
              option = {
                -- Draw completions from every loaded buffer, not just the current one.
                get_bufnrs = function()
                  return vim.api.nvim_list_bufs()
                end,
              },
              max_item_count = 10,
            },
          }
        ),

        -- ── Appearance ─────────────────────────────────────────────────────
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip  = "[Snip]",
              buffer   = "[Buf]",
            })[entry.source.name]
            return vim_item
          end,
        },

        -- ── Behaviour ──────────────────────────────────────────────────────
        completion = {
          keyword_length = 1, -- trigger after the first character typed
        },

        -- Auto-highlight the first entry so <CR> always confirms something
        -- visible. Flip to cmp.PreselectMode.None if you prefer plain Enter.
        preselect = cmp.PreselectMode.Item,

        experimental = {
          ghost_text = true, -- inline preview of the top suggestion
        },
      })
    end,
  },
}
