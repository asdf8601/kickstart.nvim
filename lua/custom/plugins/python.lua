-- [[ pdbrc ]] {{{
local pdbrc_win
local current_win

function AddPdbrc()
  local file = vim.fn.expand '%:p'
  local line = vim.fn.line '.'
  local cmd = 'b ' .. file .. ':' .. line
  local full_cmd = [[!echo ']] .. cmd .. [[' >> .pdbrc]]
  vim.cmd(full_cmd)
  current_win = vim.api.nvim_get_current_win()
  if not pdbrc_win or not vim.api.nvim_win_is_valid(pdbrc_win) then
    vim.cmd '5split .pdbrc'
    pdbrc_win = vim.api.nvim_get_current_win()
  else
    vim.api.nvim_set_current_win(pdbrc_win)
  end
  vim.cmd 'norm G'
  vim.api.nvim_set_current_win(current_win)
end
-- }}}

vim.keymap.set('n', 'bp', AddPdbrc, { noremap = true, silent = true, desc = 'Add pdbrc' })

-- cells
vim.g.custom_fold_enabled = false

-- add python cells {{{
vim.keymap.set('n', '<leader>cO', 'O%%<esc>:norm gcc<cr>j', { noremap = true, desc = 'Insert a cell comment above the current line' })
vim.keymap.set('n', '<leader>co', 'o%%<esc>:norm gcc<cr>k', { noremap = true, desc = 'Insert a cell comment below the current line' })

vim.keymap.set('n', '<leader>c-', 'O<esc>80i-<esc>:norm gcc<cr>j', { noremap = true, desc = 'Insert a horizontal line of dashes above the current line' })
-- vim.keymap.set('n', 'vic', 'V?%%<cr>o/%%<cr>koj', { noremap = true, desc = 'Visually select a cell and insert a comment before and after it' })

-- }}}
function FoldExpression()
  local line = vim.fn.getline(vim.v.lnum)
  -- Delimitamos el comienzo de un pliegue en `# %%` o cualquier línea con una explicación
  if vim.v.lnum == 1 then
    return '0'
  elseif line:match '^# %%' then
    return '>1'
  else
    return '='
  end
end

function ToggleCustomFolding()
  if vim.g.custom_fold_enabled then
    -- Restauramos el plegado original (modalidad estándar)
    vim.wo.foldmethod = 'manual'
    vim.wo.foldexpr = ''
  else
    -- Activamos el plegado personalizado
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.FoldExpression()'
  end
  vim.g.custom_fold_enabled = not vim.g.custom_fold_enabled
end

-- Crea un comando de Neovim
vim.api.nvim_command 'command! ToggleFolding lua ToggleCustomFolding()'
local function next_cell()
  vim.fn.search(vim.g.slime_cell_delimiter)
end

local function prev_cell()
  vim.fn.search(vim.g.slime_cell_delimiter, 'b')
end

local slime_get_jobid = function()
  local buffers = vim.api.nvim_list_bufs()
  local terminal_buffers = { 'Select terminal:\tjobid\tname' }
  local name = ''
  local jid = 1
  local chosen_terminal = 1

  for _, buf in ipairs(buffers) do
    if vim.bo[buf].buftype == 'terminal' then
      jid = vim.api.nvim_buf_get_var(buf, 'terminal_job_id')
      name = vim.api.nvim_buf_get_name(buf)
      table.insert(terminal_buffers, jid .. '\t' .. name)
    end
  end

  -- if there is more than one terminal, ask which one to use
  if #terminal_buffers > 2 then
    chosen_terminal = vim.fn.inputlist(terminal_buffers)
  else
    chosen_terminal = jid
  end

  if chosen_terminal then
    print('\n[slime] jobid chosen: ', chosen_terminal)
    return chosen_terminal
  else
    print 'No terminal found'
  end
end

local function slime_use_tmux()
  vim.b.slime_config = nil
  vim.g.slime_target = 'tmux'
  vim.g.slime_bracketed_paste = 1
  vim.g.slime_python_ipython = 0
  vim.g.slime_no_mappings = 1
  vim.g.slime_default_config = { socket_name = 'default', target_pane = ':.2' }
  vim.g.slime_dont_ask_default = 1
end

local function slime_use_neovim()
  vim.b.slime_config = nil
  vim.g.slime_target = 'neovim'
  vim.g.slime_bracketed_paste = 1
  vim.g.slime_python_ipython = 1
  vim.g.slime_no_mappings = 1

  if vim.fn.has 'mac' == 0 then
    vim.g.slime_get_jobid = slime_get_jobid
  end
  -- vim.g.slime_get_jobid = slime_get_jobid
  vim.g.slime_default_config = nil
  vim.g.slime_dont_ask_default = 0
end

return {
  {
    'jpalardy/vim-slime',
    init = function()
      -- options
      vim.g.slime_last_channel = { nil }
      vim.g.slime_cell_delimiter = '\\s*#\\s*%%'
      vim.g.slime_paste_file = os.getenv 'HOME' .. '/.slime_paste'

      -- new user command
      vim.api.nvim_create_user_command('SlimeConfigTarget', function(opts)
        vim.b.slime_config = nil
        if opts.args == 'tmux' then
          slime_use_tmux()
        elseif opts.args == 'neovim' then
          slime_use_neovim()
        else
          vim.g.slime_target = opts.args
        end
      end, { desc = 'Change Slime target', nargs = '*' })

      slime_use_neovim()

      -- keymaps
      vim.keymap.set('n', '<leader>e', vim.cmd.SlimeSend, { noremap = true, desc = 'send line to term' })
      vim.keymap.set('n', '<leader>cv', vim.cmd.SlimeConfig, { noremap = true, desc = 'Open slime configuration' })
      vim.keymap.set('x', '<leader>e', '<Plug>SlimeRegionSend', { noremap = true, desc = 'send line to tmux' })
      vim.keymap.set('n', '<leader>ep', '<Plug>SlimeParagraphSend', { noremap = true, desc = 'Send Paragraph with Slime' })
      vim.keymap.set('n', '<leader>ck', prev_cell, { noremap = true, desc = 'Search backward for slime cell delimiter' })
      vim.keymap.set('n', '<leader>cj', next_cell, { noremap = true, desc = 'Search forward for slime cell delimiter' })
      vim.keymap.set('n', '<leader>cc', '<Plug>SlimeSendCell', { noremap = true, desc = 'Send cell to slime' })
    end,
  },
  {
    'goerz/jupytext.vim',
    config = function()
      vim.g.jupytext_fmt = 'py:percent'
    end,
  },
}
