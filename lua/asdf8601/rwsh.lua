local function RunSh(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
  local cmd = table.concat(lines, '\n')
  local output = vim.fn.systemlist(cmd)
  vim.api.nvim_buf_set_lines(0, opts.line2, opts.line2, false, output)
end
vim.api.nvim_create_user_command('RunSh', RunSh, { range = true })
vim.keymap.set('v', '<leader>r', ':RunSh<CR>', { desc = 'Run selected lines as shell command' })
