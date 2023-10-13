
-- [[ neotest ]] {{
vim.keymap.set('n', '<leader>tn', vim.cmd.TestNearest, { noremap = true, desc = 'Run nearest test' })
vim.keymap.set('n', '<leader>tf', vim.cmd.TestFile, { noremap = true, desc = 'Run current file tests' })
vim.keymap.set('n', '<leader>ts', vim.cmd.TestSuite, { noremap = true, desc = 'Run test suite' })
vim.keymap.set('n', '<leader>tl', vim.cmd.TestLast, { noremap = true, desc = 'Run last test' })
vim.keymap.set('n', '<leader>td', function() require("neotest").run.run({ strategy = "dap" }) end , { noremap = true, desc = 'Run test debug mode' })
-- }}

return {}
