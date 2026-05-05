return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,   -- treesitter does not support lazy loading
  config = function()
    require("nvim-treesitter").setup({

      ensure_installed = {
        "c",       -- C
        "cpp",     -- C++
        "python",  -- Python
        -- recommended to also keep these
        "vim",
        "vimdoc",
        "query",
        "lua",
      },

      -- Install parsers synchronously (first time only)
      sync_install = false,

      -- Auto-install missing parsers when opening a file
      auto_install = true,

      highlight = {
        enable = true,

        -- Disable for very large files (optional, prevents slowdowns)
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,

        -- Some people also use this to prevent double-highlighting
        -- when a treesitter parser exists for the language.
        additional_vim_regex_highlighting = false,
      },
    })
  end,
}
