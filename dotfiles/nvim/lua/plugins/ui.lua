return {
    {
    	"ellisonleao/gruvbox.nvim",
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000,  -- make sure to load this before all the other start plugins
      config = function()
          vim.cmd( [[colorscheme gruvbox]] )
      end,
    },
    {
      "pappasam/papercolor-theme-slim",
      lazy = true,
    },
    {
      "yorik1984/newpaper.nvim",
      lazy = true,
    },
    {
      "tanvirtin/monokai.nvim",
      lazy = true,
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
          icons_enabled = true, theme = "onedark",
        },
        section = {
          lualine_a = { 'filename', path = 1, }
        },
      },
    },
}

