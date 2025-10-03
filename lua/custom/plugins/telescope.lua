-- [[ telescope ]]  {{
local ignore_patterns = {
  '^.npm/',
  '^.zsh%/',
  '^.oh-my-zsh/',
  '^.cache/',
  '^.tmux/',
  '/venv/',
  '.venv/',
  '.git/',
  'node_modules/',
  '*.pyc',
  'cache',
  '%.pkl',
  '%.pickle',
  '%.mat',
}

local function search_scio()
  -- function to edit a file
  local vim_edit_prompt = function(prompt_bufnr)
    local current_picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
    local prompt = current_picker:_get_prompt()
    local cwd = current_picker.cwd
    require('telescope.actions').close(prompt_bufnr)
    vim.cmd('edit ' .. cwd .. '/' .. prompt)
    return true
  end
  require('telescope.builtin').find_files {
    prompt_title = '< scio >',
    cwd = '~/github/mmngreco/scio',
    hidden = true,
    no_ignore = true,
    attach_mappings = function(_, map)
      map('i', '<c-n>', vim_edit_prompt)
      return true
    end,
  }
end

local function search_vimrc()
  require('telescope.builtin').find_files {
    prompt_title = '< .config/nvim >',
    cwd = '$HOME/.config/nvim',
    hidden = true,
    no_ignore = true,
  }
end

local function search_dotfiles()
  require('telescope.builtin').find_files {
    prompt_title = '< dotfiles >',
    cwd = '$DOTFILES_HOME',
    hidden = true,
    no_ignore = true,
  }
end

local function my_find_files()
  require('telescope.builtin').find_files {
    file_ignore_patterns = ignore_patterns,
    hidden = true,
    no_ignore = true,
    follow = true,
  }
end

local function git_branches()
  require('telescope.builtin').git_branches {
    attach_mappings = function(_, map)
      map('i', '<c-d>', require('telescope.actions').git_delete_branch)
      map('n', '<c-d>', require('telescope.actions').git_delete_branch)
      map('i', '<c-b>', require('telescope.actions').git_create_branch)
      return true
    end,
  }
end

local function find_files_from_project_git_root()
  local function is_git_repo()
    vim.fn.system 'git rev-parse --is-inside-work-tree'
    return vim.v.shell_error == 0
  end
  local function get_git_root()
    local dot_git_path = vim.fn.finddir('.git', '.;')
    return vim.fn.fnamemodify(dot_git_path, ':h')
  end
  local opts = {
    file_ignore_patterns = ignore_patterns,
    hidden = true,
  }
  if is_git_repo() then
    opts['cwd'] = get_git_root()
  end
  require('telescope.builtin').find_files(opts)
end

local new_maker = function(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.expand(filepath)
  vim.uv.fs_stat(filepath, function(_, stat)
    if not stat then
      return
    end
    if stat.size > 100000 then
      return
    else
      require('telescope.previewers').buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

local find_project = function()
  require('telescope.builtin').find_files {
    prompt_title = 'Find Directories',
    cwd = vim.fn.expand '~',
    find_command = {
      'find',
      vim.fn.expand '~/github.com/seedtag',
      vim.fn.expand '~/github.com/asdf8601',
      '-maxdepth',
      '1',
      '-type',
      'd',
      '-name',
      '.git',
      '-prune',
      '-o',
      '-type',
      'd',
      '-print',
    },
    attach_mappings = function(prompt_bufnr, map)
      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'

      local function open_in_new_window()
        local selection = action_state.get_selected_entry()
        require('telescope.actions').close(prompt_bufnr)
        vim.cmd 'vnew'
        vim.cmd('lcd ' .. selection.value)
        vim.cmd 'edit .'
      end

      map('i', '<CR>', open_in_new_window)
      map('n', '<CR>', open_in_new_window)

      return true
    end,
  }
end

local find_fuzzy_buffer = function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 15,
    previewer = false,
  })
end

local find_buffer_cwd = function()
  require('telescope.builtin').find_files { cwd = vim.fn.expand '%:p:h', hidden = false }
end

local find_emojis = function()
  require('telescope.builtin').symbols { sources = { 'emoji', 'kaomoji', 'gitmoji' } }
end

local find_cwd_git_files = function()
  require('telescope.builtin').git_files { cwd = vim.fn.getcwd(), hidden = false, use_git_root = false }
end
-- }}

return {
  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    -- branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    init = function()
      local actions = require 'telescope.actions'
      require('telescope').setup {
        pickers = {
          buffers = {
            mappings = {
              i = {
                ['<c-d>'] = actions.delete_buffer + actions.move_to_top,
              },
            },
          },
          find_files = {
            theme = 'ivy',
          },
          git_branches = {
            mappings = {
              i = { ['<cr>'] = actions.git_switch_branch },
            },
          },
        },
        defaults = {
          buffer_previewer_maker = new_maker,
          file_ignore_patterns = ignore_patterns,
          mappings = {
            i = {
              ['<esc>'] = actions.close,
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
        },
      }

      -- pcall(require('telescope').load_extension, 'media_files')
      -- require('telescope').load_extension('media_files')

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[telescope] [S]earch [F]iles' })
      -- vim.keymap.set('n', '<leader>fh', ':Telescope <cr>', { noremap = true, desc = "Find help", silent = false })
      -- vim.keymap.set('n', '<leader>fl', ':Telescope diagnostics<cr>', { noremap = true, desc = "[telescope] Find errors, lint, diagnostics", silent = false })
      -- vim.keymap.set('n', '<leader>sc', search_scio, { desc = "Search scio", noremap = true })

      vim.keymap.set('n', '<leader>dot', search_dotfiles, { desc = '[telescope] Search dotfiles', noremap = true })
      vim.keymap.set('n', '<leader>rc', search_vimrc, { desc = '[telescope] Search nvim config', noremap = true })

      vim.keymap.set('n', '<C-p>', find_files_from_project_git_root, { noremap = true, desc = '[telescope] Find files from git root' })
      vim.keymap.set('n', '<leader>ff', my_find_files, { desc = 'Find files', noremap = true })

      vim.keymap.set('n', '<leader>/', find_fuzzy_buffer, { desc = '[telescope] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[telescope] Find existing buffers' })
      vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[telescope] Find recently opened files' })
      vim.keymap.set('n', '<leader>fb', find_buffer_cwd, { desc = '[telescope] Search files in current buffer dir', noremap = true })
      vim.keymap.set('n', '<leader>fc', ':Telescope commands<cr>', { noremap = true, desc = '[telescope] Find commands', silent = false })
      vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[telescope] [S]earch [H]elp' })
      vim.keymap.set('n', '<leader>fj', find_project, { desc = '[telescope] Find projects and open it in a new win' })
      vim.keymap.set('n', '<leader>fk', ':Telescope keymaps<cr>', { noremap = true, desc = '[telescope] Find keymaps', silent = false })
      vim.keymap.set('n', '<leader>fp', find_cwd_git_files, { desc = '[telescope] Search git files in current buffer dir]', noremap = true })
      vim.keymap.set('n', '<leader>gc', git_branches, { desc = '[telescope] Git branches', noremap = true })
      vim.keymap.set('n', '<leader>gs', require('telescope.builtin').git_stash, { noremap = true, desc = '[telescope] Git stash' })
      vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[telescope] [S]earch [D]iagnostics across workspace' })
      vim.keymap.set('n', 'ts', find_emojis, { desc = '[telescope] Search emoji', noremap = true })
      vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[telescope] [S]earch by [G]rep - Live search text across all files' })
      vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[telescope] Resume last search' })
      vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[telescope] [S]earch current [W]ord under cursor in all files' })
    end,
  },
}
