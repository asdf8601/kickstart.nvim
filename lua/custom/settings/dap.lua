-- [[ dap ]] {{
require("dapui").setup()
require("nvim-dap-virtual-text").setup({})
require("dap-python").setup(os.getenv('HOME') .. '/.venv-nvim/bin/python')

local dap = require('dap')
vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { noremap = true, desc = 'dap set breakpoint condition' })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { noremap = true, desc = 'dap toggle breakpoint' })
vim.keymap.set('n', '<leader>dc', dap.continue, { noremap = true, desc = 'dap continue' })

vim.keymap.set('n', '<leader>dh', dap.step_out, { noremap = true, desc = 'dap step out ←' })
vim.keymap.set('n', '<leader>dl', dap.step_into, { noremap = true, desc = 'dap step into →' })
vim.keymap.set('n', '<leader>dk', dap.step_back, { noremap = true, desc = 'dap step back ↑' })
vim.keymap.set('n', '<leader>dj', dap.step_over, { noremap = true, desc = 'dap step over ↓' })

vim.keymap.set('n', '<leader>de', dap.repl.open, { noremap = true, desc = 'dap open repl' })
vim.keymap.set('n', '<leader>dr', dap.run_last, { noremap = true, desc = 'dap run last' })
vim.keymap.set('n', '<leader>dq', dap.disconnect, { noremap = true, desc = 'dap disconnect' })

-- [[ dap:ui ]]
local dapui = require('dapui')
vim.keymap.set('n', '<leader>du', dapui.toggle, { noremap = true, desc = 'toggle dap ui' })
vim.keymap.set('n', '<leader>do', dapui.open, { noremap = true, desc = 'toggle dap ui' })
vim.keymap.set('n', '<leader>dx', dapui.close, { noremap = true, desc = 'toggle dap ui' })
-- }}

return {}
