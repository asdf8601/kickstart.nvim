
-- [[ neotest ]] {{
vim.keymap.set('n', '<leader>tn', ':TestNearest<cr>', { noremap = true, desc = 'Run nearest test' })
vim.keymap.set('n', '<leader>tf', ':TestFile<cr>', { noremap = true, desc = 'Run current file tests' })
vim.keymap.set('n', '<leader>ts', ':TestSuite<cr>', { noremap = true, desc = 'Run test suite' })
vim.keymap.set('n', '<leader>tl', ':TestLast<cr>', { noremap = true, desc = 'Run last test' })
vim.keymap.set('n', '<leader>td', function() require("neotest").run.run({ strategy = "dap" }) end , { noremap = true, desc = 'Run test debug mode' })
-- }}

return {}
