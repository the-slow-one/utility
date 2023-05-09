-- https://neovim.io/doc/user/index.html
vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

vim.wo.number = true

vim.cmd [[ set mouse=a ]]
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
