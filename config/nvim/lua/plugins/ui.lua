local function getColorScheme()
  if os.getenv("WHITE_BACKGROUND") == "1" then return  {
      "pappasam/papercolor-theme-slim",
      lazy = false,
      priority = 1000,  -- make sure to load this before all the other start plugins
      config = function()
          vim.cmd( [[set background=light]] )
          vim.cmd( [[colorscheme PaperColorSlim]] )
      end,
    }
  else
    return  {
      "shaunsingh/nord.nvim",
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000,  -- make sure to load this before all the other start plugins
      config = function()
          vim.cmd( [[colorscheme nord]] )
      end,
    }
  end
end

local function getLuaLineTheme()
  if os.getenv("WHITE_BACKGROUND") == "1" then
    return "papercolor_light"
  else
    return "nord"
  end
end

return {
    getColorScheme(),
    {
      "nvim-tree/nvim-web-devicons",
      lazy = true,
      opts = {
        true,
      },
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      opts = {
        options = {
          icons_enabled = true, theme = getLuaLineTheme(),
        },
        section = {
          lualine_a = { 'filename', file_status = true, path = 2, }
        },
      },
    },
    {
      "lewis6991/hover.nvim",
      config = function()
          require("hover").setup {
              init = function()
                  -- Require providers
                  require("hover.providers.lsp")
                  require('hover.providers.gh')
                  require('hover.providers.gh_user')
                  -- require('hover.providers.jira')
                  -- require('hover.providers.dap')
                  -- require('hover.providers.man')
                  require('hover.providers.dictionary')
              end,
              preview_opts = {
                  border = 'single'
              },
              -- Whether the contents of a currently open hover window should be moved
              -- to a :h preview-window when pressing the hover keymap.
              preview_window = false,
              title = true,
              mouse_providers = {
                  'LSP'
              },
              mouse_delay = 1000
          }

          -- Setup keymaps
          vim.keymap.set("n", "K", require("hover").hover, {desc = "hover.nvim"})
          vim.keymap.set("n", "gK", require("hover").hover_select, {desc = "hover.nvim (select)"})
          vim.keymap.set("n", "<C-p>", function() require("hover").hover_switch("previous") end, {desc = "hover.nvim (previous source)"})
          vim.keymap.set("n", "<C-n>", function() require("hover").hover_switch("next") end, {desc = "hover.nvim (next source)"})

          -- Mouse support
          vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = "hover.nvim (mouse)" })
          vim.o.mousemoveevent = true
      end
    },
    {
      "nvim-zh/colorful-winsep.nvim",
      config = true,
      event = { "WinNew" },
    },
}
