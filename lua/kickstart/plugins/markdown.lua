-- [markdown]
vim.keymap.set('n', '<leader>tu', 'yypVr-', { noremap = true, desc = 'underline word under cursor' })
vim.keymap.set('n', '<leader>tx', ':s/\\[\\s\\?\\]/[x]/<cr>', { noremap = true, desc = 'check a box in markdown' })
vim.keymap.set('n', '<leader>t<space>', ':s/\\[x\\]/[ ]/<cr>', { noremap = true, desc = 'uncheck a box in markdown' })
vim.keymap.set('n', '<leader>tc', 'I- [ ] <esc>', { noremap = true, desc = 'append empty checkbox in markdown' })
vim.keymap.set('n', '<leader>m', ':MaximizerToggle<cr>', { noremap = true, desc = 'Maximize current window' })

vim.keymap.set('n', '<leader>zz', '<cmd>ZenMode<cr>', { noremap = true, desc = 'ZenMode toggle' })
vim.keymap.set('v', '<leader>h', ':<c-u>HSHighlight 2<cr>', { noremap = true, desc = 'high-str' })
-- vim.keymap.set("n", "<leader>h", ":<c-u>HSHighlight 2<cr>", {noremap = true, desc = 'high-str'})

return {
  'mzlogin/vim-markdown-toc',
  {
    -- A hackable Markdown, HTML, LaTeX, Typst & YAML previewer for Neovim.
    -- https://github.com/OXY2DEV/markview.nvim
    'OXY2DEV/markview.nvim',
    ft = { 'markdown' },
    config = function()
      require('markview').setup {
        preview = {
          icon_provider = 'internal', -- "internal", "mini" or "devicons"
        },
      }
      require('markview.extras.editor').setup()
      require('markview.extras.checkboxes').setup {
        default = 'X',
        remove_style = 'disable', -- disable, checkbox, list_item
        states = {
          { ' ', '/', 'X' },
          { '<', '>' },
          { '?', '!', '*' },
          { '"' },
          { 'l', 'b', 'i' },
          { 'S', 'I' },
          { 'p', 'c' },
          { 'f', 'k', 'w' },
          { 'u', 'd' },
        },
      }
    end,
    dependencies = {
      'saghen/blink.cmp',
    },
  },
}
