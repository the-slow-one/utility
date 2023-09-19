local function getColorScheme()
  if os.getenv("WHITE_BACKGROUND") == "1" then return  {
      "pappasam/papercolor-theme-slim",
      lazy = false,
      priority = 1000,  -- make sure to load this before all the other start plugins
      config = function()
          vim.cmd( [[colorscheme PaperColorSlim]] )
      end,
    }
  else
    return  {
    	"ellisonleao/gruvbox.nvim",
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000,  -- make sure to load this before all the other start plugins
      config = function()
          vim.cmd( [[colorscheme gruvbox]] )
      end,
    }
  end
end

local function getLuaLineTheme()
  if os.getenv("WHITE_BACKGROUND") == "1" then
    return "papercolor_light"
  else
    return "onedark"
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
}
