return {

  {
    'miikanissi/modus-themes.nvim',
    priority = 1000,
    config = function()
      require('modus-themes').setup {
        transparent = true,
      }
      -- vim.cmd.colorscheme = 'modus_vivendi'
    end,
  },
}
