local open_cmdline_with_selected_files = function()
  -- Open cmdline with visually selected entries as argument
  -- : <file1> <file2> <file..>
  local oil = require 'oil'
  local mode = string.lower(vim.api.nvim_get_mode().mode)
  local bufnr = vim.api.nvim_get_current_buf()
  local name
  local cwd = oil.get_current_dir()
  local items = {}

  local function open_cmdline_with_path(paths, m)
    local rm = ''
    local args = ''
    for _, path in ipairs(paths) do
      args = args .. ' ' .. vim.fn.fnameescape(path)
    end
    if m == 'v' then
      rm = '<Del><Del><Del><Del><Del>'
    end
    local escaped = vim.api.nvim_replace_termcodes(':! ' .. args .. '<Home>' .. rm .. '<Right>', true, false, true)
    vim.api.nvim_feedkeys(escaped, m, true)
  end

  if mode == 'n' then
    local lnum = vim.fn.getpos('.')[2]
    name = oil.get_entry_on_line(bufnr, lnum).name
    table.insert(items, cwd .. name)
  elseif mode == 'v' then
    local start = vim.fn.getpos 'v'
    local end_ = vim.fn.getpos '.'
    local lnum0 = start[2]
    local lnum1 = end_[2]
    print(lnum0, lnum1)
    for lnum = lnum0, lnum1 do
      _ = oil.get_entry_on_line(bufnr, lnum)
      name = oil.get_entry_on_line(bufnr, lnum).name
      table.insert(items, cwd .. name)
    end
  end
  open_cmdline_with_path(items, mode)
end

local open_current_entry = function()
  local oil = require 'oil'
  local cwd = oil.get_current_dir()
  local entry = oil.get_cursor_entry()
  if cwd and entry then
    vim.fn.jobstart { 'open', string.format('%s/%s', cwd, entry.name) }
  end
end
local cd = function()
  vim.cmd('cd ' .. require('oil').get_current_dir())
end

local set_oil_default_columns = function()
  require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' }
end

local find_files_in_git_root = function()
  require('telescope.builtin').find_files {
    cwd = vim.fn.systemlist('git rev-parse --show-toplevel')[1],
    hidden = true,
    exclude = { '.git', 'node_modules', '.cache' },
  }
end

local find_files_in_current_oil_directory = function()
  require('telescope.builtin').find_files {
    cwd = require('oil').get_current_dir(),
    hidden = true,
    exclude = { '.git', 'node_modules', '.cache' },
  }
end

return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    config = function()
      require('oil').setup {
        view_options = {
          show_hidden = true,
        },
        default_file_explorer = true,
        keymaps = {
          ['<C-v>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open entry in a vertical split' },
          ['<C-h>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open entry in a horizontal split' },
          ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open entry in a new tab' },
          ['cd'] = { cd, desc = 'Change to current directory' },
          ['~'] = { '<cmd>edit $HOME<CR>', desc = 'Go to home directory' },
          ['`'] = { 'actions.tcd', desc = 'Change to current directory' },
          ['gd'] = { set_oil_default_columns, desc = 'Set default Oil columns' },
          ['ff'] = { find_files_in_current_oil_directory, mode = 'n', nowait = true, desc = 'Find files in the current directory' },
          ['<C-p>'] = { find_files_in_git_root, mode = 'n', nowait = true, desc = 'Find files in the current directory' },
          ['go'] = { open_current_entry, desc = 'Open current entry externaly' },
          ['!'] = { open_cmdline_with_selected_files, desc = 'cmdline with selected items' },
          ['<leader>:'] = {
            'actions.open_cmdline',
            opts = { shorten_path = false, modify = ':h' },
            desc = 'Open the command line with the current directory as argument',
          },
        },
      }
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    end,
  },
}
