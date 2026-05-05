return {
  'nvim-telescope/telescope.nvim', version = '*',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>lf', builtin.find_files, { desc = "Telescope: Find files" })
    vim.keymap.set('n', '<leader>lg', builtin.live_grep, { desc = "Telescope: Live grep" })
    vim.keymap.set('n', '<leader>lb', builtin.buffers, { desc = "Telescope: Find buffers" })
    vim.keymap.set('n', '<leader>lh', builtin.help_tags, { desc = "Telescope: Help" })
  end
}
