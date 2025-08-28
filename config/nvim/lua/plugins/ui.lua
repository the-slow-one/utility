local function getLuaLineTheme()
  if os.getenv("WHITE_BACKGROUND") == "1" then
    return "gruvbox_light"
  else
    return "nord"
  end
end

return {
    {
      'lmantw/themify.nvim',
      lazy = false,
      priority = 999,
      opts = {
        "pappasam/papercolor-theme-slim",
        "EdenEast/nightfox.nvim",
        "shaunsingh/nord.nvim",
        "default",
      },
    },
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
      opts = {
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
          preview_opts = { border = 'single' },
          -- Whether the contents of a currently open hover window should be moved
          -- to a :h preview-window when pressing the hover keymap.
          preview_window = false,
          title = true,
          mouse_providers = { 'LSP' },
          mouse_delay = 1000
      },
      init = function()
        -- Setup keymaps
        vim.keymap.set("n", "K", require("hover").hover, {desc = "hover.nvim"})
        vim.keymap.set("n", "gK", require("hover").hover_select, {desc = "hover.nvim (select)"})
        vim.keymap.set("n", "<C-p>", function() require("hover").hover_switch("previous") end, {desc = "hover.nvim (previous source)"})
        vim.keymap.set("n", "<C-n>", function() require("hover").hover_switch("next") end, {desc = "hover.nvim (next source)"})

        -- Mouse support
        vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = "hover.nvim (mouse)" })
        vim.o.mousemoveevent = true
      end,
    },
    {
      "nvim-zh/colorful-winsep.nvim",
      config = true,
      event = { "WinNew" },
    },
}
