-- [[ jupytext ]]
vim.g.jupytext_filetype_map = { py = 'python' }
vim.g.jupytext_fmt = 'py:percent'

vim.g.slime_cell_delimiter = [[\s*#\s*%%]]
vim.g.slime_paste_file = os.getenv("HOME") .. "/.slime_paste"
local function next_cell()
    vim.cmd.search(vim.g.slime_cell_delimiter)
end

local function prev_cell()
    vim.cmd.search(vim.g.slime_cell_delimiter, "b")
end
vim.keymap.set('n', '<leader>e', vim.cmd.SlimeSend, { noremap = true, desc = 'send line to term' })
vim.keymap.set('x', '<leader>e', '<Plug>SlimeRegionSend', { noremap = true, desc = 'send line to tmux' })
vim.keymap.set('n', '<leader>cv', vim.cmd.SlimeConfig, { noremap = true, desc = "Open SlimeConfig" })
vim.keymap.set('n', '<leader>ep', vim.cmd.SlimeParagraphSend, { noremap = true, desc = "Send Paragraph with Slime" })
-- vim.keymap.set('n', '<leader>cc', '<Plug>SlimeSendCell', {noremap = true})
vim.keymap.set('n', '<leader>ck', prev_cell, { noremap = true, desc = "Search backward for slime cell delimiter" })
vim.keymap.set('n', '<leader>cj', next_cell, { noremap = true, desc = "Search forward for slime cell delimiter" })
vim.keymap.set('n', '<leader>cv', vim.cmd.SlimeConfig, { noremap = true, desc = "Open slime configuration" })
vim.keymap.set('n', '<leader>ep', vim.cmd.SlimeParagraphSend, { noremap = true, desc = "Send paragraph to slime" })
vim.keymap.set('n', '<leader>cc', vim.cmd.SlimeSendCell, { noremap = true, desc = "Send cell to slime" })

local function slime_use_tmux()
  vim.g.slime_target = "tmux"
  vim.g.slime_bracketed_paste = 1
  vim.g.slime_python_ipython = 0
  vim.g.slime_no_mappings = 1
  vim.g.slime_default_config = { socket_name = "default", target_pane = ":.2" }
  vim.g.slime_dont_ask_default = 1
end

local function slime_use_neovim()
  vim.g.slime_target = "neovim"
  vim.g.slime_bracketed_paste = 0
  vim.g.slime_python_ipython = 1
  -- vim.g.slime_default_config = {}
  vim.g.slime_no_mappings = 1
  vim.g.slime_dont_ask_default = 0
end

-- slime_use_neovim()
slime_use_tmux()
local function toggle_slime_target()
  if vim.g.slime_target == "neovim" then
    slime_use_tmux()
  else
    slime_use_neovim()
  end
end

vim.api.nvim_create_user_command('SlimeToggleTarget', toggle_slime_target, { nargs = 0 })


return {}
