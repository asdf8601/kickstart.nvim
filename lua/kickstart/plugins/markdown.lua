-- [markdown]
vim.keymap.set('n', '<leader>tu', 'yypVr-', { noremap = true, desc = 'underline word under cursor' })
vim.keymap.set('n', '<leader>tx', ':s/\\[\\s\\?\\]/[x]/<cr>', { noremap = true, desc = 'check a box in markdown' })
vim.keymap.set('n', '<leader>t<space>', ':s/\\[x\\]/[ ]/<cr>', { noremap = true, desc = 'uncheck a box in markdown' })
vim.keymap.set('n', '<leader>tc', 'I- [ ] <esc>', { noremap = true, desc = 'append empty checkbox in markdown' })
vim.keymap.set('n', '<leader>m', ':MaximizerToggle<cr>', { noremap = true, desc = 'Maximize current window' })

vim.keymap.set('v', '<leader>h', ':<c-u>HSHighlight 2<cr>', { noremap = true, desc = 'high-str' })
-- vim.keymap.set("n", "<leader>h", ":<c-u>HSHighlight 2<cr>", {noremap = true, desc = 'high-str'})

return {
  {
    -- Render markdown in normal mode with treesitter, here and in avante chats
    'MeanderingProgrammer/render-markdown.nvim',
    lazy = false, -- an ft trigger makes lazy.nvim re-fire FileType, which starts treesitter twice
    opts = { file_types = { 'markdown', 'Avante' } },
  },
}
