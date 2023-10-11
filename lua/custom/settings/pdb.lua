-- [[ pdbrc ]] {{
local pdbrc_win
local current_win

function AddPdbrc()
  local file = vim.fn.expand('%:p')
  local line = vim.fn.line('.')
  local cmd = "b " .. file .. ":" .. line
  local full_cmd = [[!echo ']] .. cmd .. [[' >> .pdbrc]]
  vim.cmd(full_cmd)
  current_win = vim.api.nvim_get_current_win()
  if not pdbrc_win or not vim.api.nvim_win_is_valid(pdbrc_win) then
    vim.cmd('5split .pdbrc')
    pdbrc_win = vim.api.nvim_get_current_win()
  else
    vim.api.nvim_set_current_win(pdbrc_win)
  end
  vim.cmd('norm G')
  vim.api.nvim_set_current_win(current_win)
end

vim.keymap.set('n', 'bp', AddPdbrc, { noremap = true, silent = true, desc = 'Add pdbrc' })

return {}
