return {
  'nvim-telescope/telescope.nvim', version = '*',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Telescope: Find files" })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Telescope: Live grep" })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Telescope: Find buffers" })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Telescope: Help" })
  end
}
