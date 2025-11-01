-- [markdown]
vim.keymap.set('n', '<leader>tu', 'yypVr-', { noremap = true, desc = 'underline word under cursor' })
vim.keymap.set('n', '<leader>tx', ':s/\\[\\s\\?\\]/[x]/<cr>', { noremap = true, desc = 'check a box in markdown' })
vim.keymap.set('n', '<leader>t<space>', ':s/\\[x\\]/[ ]/<cr>', { noremap = true, desc = 'uncheck a box in markdown' })
vim.keymap.set('n', '<leader>ta', 'I- [ ] <esc>', { noremap = true, desc = 'append empty checkbox in markdown' })
vim.keymap.set('n', '<leader>m', ':MaximizerToggle<cr>', { noremap = true, desc = 'Maximize current window' })

vim.keymap.set('n', '<leader>/', '/<C-r><C-w>', { desc = '[S]earch [R]esume' })

vim.keymap.set('n', '<leader>zz', '<cmd>ZenMode<cr>', { noremap = true, desc = 'ZenMode toggle' })
vim.keymap.set('v', '<leader>h', ':<c-u>HSHighlight 2<cr>', { noremap = true, desc = 'high-str' })
-- vim.keymap.set("n", "<leader>h", ":<c-u>HSHighlight 2<cr>", {noremap = true, desc = 'high-str'})
--
-- [[markdown]] {{{
-- vim.g.markdown_fenced_languages = { 'html', 'python', 'bash=sh', 'sql', 'mermaid' }
-- vim.g.markdown_minlines = 50
-- TODO: fill this
-- vim.g.mkdp_markdown_css = ''
vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 0
vim.g.mkdp_page_title = '${name}'
vim.g.mkdp_theme = 'light'
-- }}}

return {
  'mzlogin/vim-markdown-toc',
  {
    -- A hackable Markdown, HTML, LaTeX, Typst & YAML previewer for Neovim.
    -- https://github.com/OXY2DEV/markview.nvim
    'OXY2DEV/markview.nvim',
    lazy = false,
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
