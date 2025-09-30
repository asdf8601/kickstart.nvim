-- local ignore_patterns = {
--   '^.npm/',
--   '^.zsh%/',
--   '^.oh-my-zsh/',
--   '^.cache/',
--   '^.tmux/',
--   '/venv/',
--   '.venv/',
--   '.git/',
--   'node_modules/',
--   '*.pyc',
--   'cache',
--   '%.pkl',
--   '%.pickle',
--   '%.mat',
-- }

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
      local actions = require('telescope.actions')
      require('telescope').setup {
        pickers = {
          find_files = {
            theme = "ivy",
          },
          git_branches = {
            mappings = {
              i = { ["<cr>"] = actions.git_switch_branch },
            },
          },
        },
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
      -- vim.keymap.set('n', '<leader>/', function()
      --   -- You can pass additional configuration to telescope to change theme, layout, etc.
      --   require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      --     winblend = 15,
      --     previewer = false,
      --   })
      -- end, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<C-p>', require('telescope.builtin').git_files, { desc = '[telescope] Search [G]it [F]iles' })
      vim.keymap.set('n', '<leader>fp', "<cmd>lua require('telescope.builtin').git_files( { cwd = vim.fn.getcwd(), hidden = false, use_git_root=false }) <CR>", { desc = "[telescope] Search git files in current buffer dir]", noremap = true })
      vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[telescope] [S]earch [F]iles' })
      vim.keymap.set('n', "<leader>fb", "<cmd>lua require('telescope.builtin').find_files( { cwd = vim.fn.expand('%:p:h'), hidden = false }) <CR>", { desc = "[telescope] Search files in current buffer dir", noremap = true })
      vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[telescope] [S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[telescope] [S]earch current [W]ord under cursor in all files' })
      vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[telescope] [S]earch by [G]rep - Live search text across all files in workspace' })
      vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[telescope] [S]earch [D]iagnostics across workspace' })
      vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[telescope] Resume last search' })
      -- vim.keymap.set('n', '<leader>fl', ':Telescope diagnostics<cr>', { noremap = true, desc = "[telescope] Find errors, lint, diagnostics", silent = false })
      vim.keymap.set('n', '<leader>fc', ':Telescope commands<cr>', { noremap = true, desc = "[telescope] Find commands", silent = false })
      vim.keymap.set('n', '<leader>fk', ':Telescope keymaps<cr>', { noremap = true, desc = "[telescope] Find keymaps", silent = false })

      vim.keymap.set('n', '<leader>fj', function()
        require('telescope.builtin').find_files({
          prompt_title = "Find Directories",
          cwd = vim.fn.expand('~'),
          find_command = { 'find', vim.fn.expand('~/github.com/seedtag'), vim.fn.expand('~/github.com/asdf8601'), '-maxdepth', '1', '-type', 'd', '-name', '.git', '-prune', '-o', '-type', 'd', '-print' },
          attach_mappings = function(prompt_bufnr, map)
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')

            local function open_in_new_window()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              vim.cmd('vnew')
              vim.cmd('lcd ' .. selection.value)
              vim.cmd('edit .')
            end

            map('i', '<CR>', open_in_new_window)
            map('n', '<CR>', open_in_new_window)

            return true
          end,
        })
        end, { desc = '[telescope] Find projects and open it in a new win' })
      end
  },
}
