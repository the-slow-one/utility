require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'onelight',
  },
  section = {
    lualine_a = {
      {
        'filename',
        path = 1,
      }
    }
  }
}
