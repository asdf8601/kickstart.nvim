-- toggle numbers
vim.g.number = 1

function ToggleNumbers()
  if vim.g.number == 1 then
    vim.g.number = 0
    vim.o.number = false
    vim.o.relativenumber = false
    vim.o.signcolumn = 'no'
  else
    vim.g.number = 1
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.signcolumn = 'yes'
  end
end
vim.api.nvim_create_user_command('ToggleNumbers', ToggleNumbers, {})

-- bucket
function GetVisual(mode)
  local data
  local _, ls, cs = unpack(vim.fn.getpos 'v')
  local _, le, ce = unpack(vim.fn.getpos '.')
  if mode == 'V' then
    data = vim.api.nvim_buf_get_lines(0, ls - 1, le - 1, false)
  else
    data = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
  end
  return table.concat(data, '\\n')
end

local function GsutilImport()
  local bucket = ''
  local mode = vim.fn.mode()

  if mode == 'v' or mode == 'V' then
    bucket = GetVisual(mode)
  else
    bucket = vim.fn.expand '<cWORD>'
  end

  -- remove spaces, qoutes and new lines
  bucket = bucket:gsub('\\n', ''):gsub('%s+', ''):gsub('"', ''):gsub("'", '')

  if not string.match(bucket, 'gs://') then
    vim.print 'Not a valid bucket'
    return
  end

  local tmpfile = '/tmp/' .. string.match(bucket, '[^gs://].*$')
  local cmd = string.format('gsutil -m cp -r %s %s', bucket, tmpfile)
  vim.print(cmd)
  local out = vim.fn.system(cmd)
  vim.print(out)
  vim.cmd.edit(tmpfile)
end

vim.api.nvim_create_user_command('GsutilImport', GsutilImport, { nargs = 0 })
vim.api.nvim_set_keymap('n', '<leader>gg', ':GsutilImport<cr>', { noremap = true, silent = false })

-- Examples
-- ========
-- "gs://hola/mundo/que/tal/estas.txt"
-- 'gs://hola/mundo/que/tal/estas.txt'
-- gs://hola/mundo/que/tal/

return {
  -- 'tpope/vim-unimpaired',
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
  'RRethy/vim-illuminate',
  'folke/zen-mode.nvim',
  'junegunn/vim-easy-align',
  'lunarVim/bigfile.nvim',
  'mzlogin/vim-markdown-toc',
  'szw/vim-maximizer',
  'tpope/vim-dispatch',
  'tpope/vim-fugitive', -- git extension
  'tpope/vim-repeat', -- better repeat
  'tpope/vim-rhubarb', -- github extension
  'tpope/vim-sleuth',
  'tpope/vim-speeddating',

  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },

  {
    'mbbill/undotree',
    init = function()
      vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { noremap = true, desc = 'Open/close UndoTree' })
    end,
  },

  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    -- branch='v0.6', --recommended as each new version will have breaking changes
    opts = {
      --Config goes here
    },
  },
  {
    -- git diff view
    'sindrets/diffview.nvim',
    cmd = 'DiffviewOpen',
  },
  {
    -- A Neovim plugin that display prettier diagnostic messages. Display one
    -- line diagnostic messages where the cursor is, with icons and colors.
    -- https://github.com/rachartier/tiny-inline-diagnostic.nvim
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy', -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require('tiny-inline-diagnostic').setup {
        -- Style preset for diagnostic messages
        -- Available options:
        -- "modern", "classic", "minimal", "powerline",
        -- "ghost", "simple", "nonerdfont", "amongus"
        preset = 'nonerdfont',
        -- Configuration for breaking long messages into separate lines
        options = {
          break_line = {
            -- Enable the feature to break messages after a specific length
            enabled = true,
            -- Number of characters after which to break the line
            after = 30,
          },
        },
      }
      vim.diagnostic.config { virtual_text = false } -- Only if needed in your configuration, if you already have native LSP diagnostics
    end,
  },

  {
    -- A hackable Markdown, HTML, LaTeX, Typst & YAML previewer for Neovim.
    -- https://github.com/OXY2DEV/markview.nvim
    'OXY2DEV/markview.nvim',
    lazy = false,
    config = function()
      require('markview').setup {
        preview = {
          icon_provider = 'internal', -- "internal", "mini" or "devicons"
        },
      }

      require('markview.extras.editor').setup()

      require('markview.extras.checkboxes').setup {
        --- Default checkbox state(used when adding checkboxes).
        ---@type string
        default = 'X',

        --- Changes how checkboxes are removed.
        ---@type
        ---| "disable" Disables the checkbox.
        ---| "checkbox" Removes the checkbox.
        ---| "list_item" Removes the list item markers too.
        remove_style = 'disable',

        --- Various checkbox states.
        ---
        --- States are in sets to quickly change between them
        --- when there are a lot of states.
        ---@type string[][]
        states = {
          { ' ', '/', 'X' },
          { '<', '>' },
          { '?', '!', '*' },
          { '"' },
          { 'l', 'b', 'i' },
          { 'S', 'I' },
          { 'p', 'c' },
          { 'f', 'k', 'w' },
          { 'u', 'd' },
        },
      }
    end,
    dependencies = {
      'saghen/blink.cmp',
    },
  },


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

          ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
          ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
          ['<C-t>'] = { 'actions.select', opts = { tab = true } },
          ['cd'] = function()
            vim.cmd('cd ' .. require('oil').get_current_dir())
          end,

          ['~'] = '<cmd>edit $HOME<CR>',

          ['`'] = 'actions.tcd',

          ['gd'] = {
            function()
              require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' }
            end,
          },

          ['ff'] = {
            function()
              require('telescope.builtin').find_files {
                cwd = require('oil').get_current_dir(),
                hidden = true,
                exclude = { '.git', 'node_modules', '.cache' },
              }
            end,
            mode = 'n',
            nowait = true,
            desc = 'Find files in the current directory',
          },

          ['<C-p>'] = {
            function()
              require('telescope.builtin').find_files {
                cwd = vim.fn.systemlist('git rev-parse --show-toplevel')[1],
                hidden = true,
                exclude = { '.git', 'node_modules', '.cache' },
              }
            end,
            mode = 'n',
            nowait = true,
            desc = 'Find files in the current directory',
          },

          ['go'] = {
            function()
              local oil = require 'oil'
              local cwd = oil.get_current_dir()
              local entry = oil.get_cursor_entry()
              if cwd and entry then
                vim.fn.jobstart { 'open', string.format('%s/%s', cwd, entry.name) }
              end
            end,
          },

          ['!'] = {
            function()
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
            end,
          },

          ['<leader>:'] = {
            'actions.open_cmdline',
            opts = {
              shorten_path = false,
              modify = ':h',
            },
            desc = 'Open the command line with the current directory as an argument',
          },
        },
      }

      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    end,
  },

  {
    'nvim-pack/nvim-spectre',
    config = function()
      require('spectre').setup()
      vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', { desc = 'Toggle Spectre' })
      vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = 'Search current word' })
      vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = 'Search current word' })
      vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = 'Search on current file' })
    end,

    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  {
    -- A task runner and job management plugin for Neovim
    -- https://github.com/stevearc/overseer.nvim
    'stevearc/overseer.nvim',
    opts = {},
    event = 'VeryLazy',
  },

  {
    -- TODO: why?????
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
  {
    -- better quickfix
    'kevinhwang91/nvim-bqf',
    dependencies = {
      'junegunn/fzf',
      -- config = function() vim.fn['fzf#install']() end,
    },
    opts = {
      preview = {
        auto_preview = false,
      },
    },
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff', 'mypy' },
        go = { 'gofumpt' },
        -- ['_'] = { 'trim_whitespace' },
      },
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
    },
  },
  {
    'ThePrimeagen/harpoon',
    init = function()
      vim.keymap.set('n', '<C-s><C-h>', ':lua SendToHarpoon(1, 0)<CR>', { noremap = true, desc = 'Send to Harpoon (normal mode)' })
      vim.keymap.set('v', '<C-s><C-h>', ':lua SendToHarpoon(1, 1)<CR>', { noremap = true, desc = 'Send to Harpoon (visual mode)' })
      vim.keymap.set('n', '<C-h>', ':lua require("harpoon.ui").nav_file(1)<cr>', { noremap = true, desc = 'Harpoon file 1' })
      vim.keymap.set('n', '<C-j>', ':lua require("harpoon.ui").nav_file(2)<cr>', { noremap = true, desc = 'Harpoon file 2' })
      vim.keymap.set('n', '<C-k>', ':lua require("harpoon.ui").nav_file(3)<cr>', { noremap = true, desc = 'Harpoon file 3' })
      vim.keymap.set('n', '<C-l>', ':lua require("harpoon.ui").nav_file(4)<cr>', { noremap = true, desc = 'Harpoon file 4' })
      vim.keymap.set('n', '<C-h><C-h>', ':lua require("harpoon.term").gotoTerminal(1)<cr>i', { noremap = true, desc = 'Harpoon Terminal 1' })
      vim.keymap.set('n', '<C-j><C-j>', ':lua require("harpoon.term").gotoTerminal(2)<cr>i', { noremap = true, desc = 'Harpoon Terminal 2' })
      vim.keymap.set('n', '<C-k><C-k>', ':lua require("harpoon.term").gotoTerminal(3)<cr>i', { noremap = true, desc = 'Harpoon Terminal 3' })
      vim.keymap.set('n', '<C-l><C-l>', ':lua require("harpoon.term").gotoTerminal(4)<cr>i', { noremap = true, desc = 'Harpoon Terminal 4' })
      vim.keymap.set('n', '<leader>hh', ':lua require("harpoon.mark").add_file()<CR>', { desc = 'Add file to Harpoon marks' })
      vim.keymap.set('n', '<leader>hm', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', { noremap = true, desc = "Harpoon's quick menu" })
    end,
  },

  -- {
  --   -- resize window automatically
  --   "nvim-focus/focus.nvim",
  --   config = function()
  --     require('focus').setup({
  --       enable=false
  --     })
  --   end,
  -- },

  -- {
  --   -- TODO: what is this about?
  --   'Bekaboo/dropbar.nvim',
  --   -- optional, but required for fuzzy finder support
  --   dependencies = {
  --     'nvim-telescope/telescope-fzf-native.nvim',
  --     build = 'make'
  --   }
  -- },
}
