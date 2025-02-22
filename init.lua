vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

  {
    -- resize window automatically
    "nvim-focus/focus.nvim",
    config = function()
      require('focus').setup({
        enable=false
      })
    end,
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  {
    'mbbill/undotree',
    init = function()
      vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { noremap = true, desc = "Open/close UndoTree" })
    end,
  },

  {
    'jpalardy/vim-slime',
    init=function ()
      vim.g.slime_last_channel = { nil }
      vim.g.slime_cell_delimiter = '\\s*#\\s*%%'
      vim.g.slime_paste_file = os.getenv("HOME") .. "/.slime_paste"

      local function next_cell()
        vim.fn.search(vim.g.slime_cell_delimiter)
      end

      local function prev_cell()
        vim.fn.search(vim.g.slime_cell_delimiter, "b")
      end

      local slime_get_jobid = function()
        local buffers = vim.api.nvim_list_bufs()
        local terminal_buffers = { "Select terminal:\tjobid\tname", }
        local name = ""
        local jid = 1
        local chosen_terminal = 1

        for _, buf in ipairs(buffers) do
          if vim.bo[buf].buftype == 'terminal' then
            jid = vim.api.nvim_buf_get_var(buf, 'terminal_job_id')
            name = vim.api.nvim_buf_get_name(buf)
            table.insert(terminal_buffers, jid .. "\t" .. name)
          end
        end

        -- if there is more than one terminal, ask which one to use
        if #terminal_buffers > 2 then
          chosen_terminal = vim.fn.inputlist(terminal_buffers)
        else
          chosen_terminal = jid
        end

        if chosen_terminal then
          print("\n[slime] jobid chosen: ", chosen_terminal)
          return chosen_terminal
        else
          print("No terminal found")
        end
      end

      local function slime_use_tmux()
        vim.b.slime_config = nil
        vim.g.slime_target = "tmux"
        vim.g.slime_bracketed_paste = 1
        vim.g.slime_python_ipython = 0
        vim.g.slime_no_mappings = 1
        vim.g.slime_default_config = { socket_name = "default", target_pane = ":.2" }
        vim.g.slime_dont_ask_default = 1
      end

      local function slime_use_neovim()
        vim.b.slime_config = nil
        vim.g.slime_target = "neovim"
        vim.g.slime_bracketed_paste = 1
        vim.g.slime_python_ipython = 1
        vim.g.slime_no_mappings = 1

        if vim.fn.has('mac') == 0 then
          vim.g.slime_get_jobid = slime_get_jobid
        end
        -- vim.g.slime_default_config = nil
        -- vim.g.slime_dont_ask_default = 0
      end

      vim.api.nvim_create_user_command('SlimeTarget', function (opts)
        vim.b.slime_config = nil
        if opts.args == "tmux" then
          slime_use_tmux()
        elseif opts.args == "neovim" then
          slime_use_neovim()
        else
          vim.g.slime_target = opts.args
        end
      end, { desc = "Change Slime target", nargs = '*'})

      slime_use_neovim()
      vim.keymap.set('n', '<leader>e', vim.cmd.SlimeSend, { noremap = true, desc = 'send line to term' })
      vim.keymap.set('n', '<leader>cv', vim.cmd.SlimeConfig, { noremap = true, desc = "Open slime configuration" })
      vim.keymap.set('x', '<leader>e', '<Plug>SlimeRegionSend', { noremap = true, desc = 'send line to tmux' })
      vim.keymap.set('n', '<leader>ep', '<Plug>SlimeParagraphSend', { noremap = true, desc = "Send Paragraph with Slime" })
      vim.keymap.set('n', '<leader>ck', prev_cell, { noremap = true, desc = "Search backward for slime cell delimiter" })
      vim.keymap.set('n', '<leader>cj', next_cell, { noremap = true, desc = "Search forward for slime cell delimiter" })
      vim.keymap.set('n', '<leader>cc', '<Plug>SlimeSendCell', { noremap = true, desc = "Send cell to slime" })

    end
  },

  {
    'ThePrimeagen/harpoon',
    init = function()
      vim.keymap.set('n', '<C-s><C-h>', ':lua SendToHarpoon(1, 0)<CR>', { noremap = true, desc = "Send to Harpoon (normal mode)" })
      vim.keymap.set('v', '<C-s><C-h>', ':lua SendToHarpoon(1, 1)<CR>', { noremap = true, desc = "Send to Harpoon (visual mode)" })
      vim.keymap.set('n', '<C-h>', ':lua require("harpoon.ui").nav_file(1)<cr>', { noremap = true, desc = 'Harpoon file 1' })
      vim.keymap.set('n', '<C-j>', ':lua require("harpoon.ui").nav_file(2)<cr>', { noremap = true, desc = 'Harpoon file 2' })
      vim.keymap.set('n', '<C-k>', ':lua require("harpoon.ui").nav_file(3)<cr>', { noremap = true, desc = 'Harpoon file 3' })
      vim.keymap.set('n', '<C-l>', ':lua require("harpoon.ui").nav_file(4)<cr>', { noremap = true, desc = 'Harpoon file 4' })
      vim.keymap.set('n', '<C-h><C-h>', ':lua require("harpoon.term").gotoTerminal(1)<cr>i', { noremap = true, desc = "Harpoon Terminal 1" })
      vim.keymap.set('n', '<C-j><C-j>', ':lua require("harpoon.term").gotoTerminal(2)<cr>i', { noremap = true, desc = "Harpoon Terminal 2" })
      vim.keymap.set('n', '<C-k><C-k>', ':lua require("harpoon.term").gotoTerminal(3)<cr>i', { noremap = true, desc = "Harpoon Terminal 3" })
      vim.keymap.set('n', '<C-l><C-l>', ':lua require("harpoon.term").gotoTerminal(4)<cr>i', { noremap = true, desc = "Harpoon Terminal 4" })
      vim.keymap.set('n', '<leader>hh', ':lua require("harpoon.mark").add_file()<CR>', { desc = "Add file to Harpoon marks" })
      vim.keymap.set('n', '<leader>hm', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', { noremap = true, desc = "Harpoon's quick menu" })
    end,
  },

  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-sleuth',

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
    config = function()
        require('mason').setup()
        require('mason-lspconfig').setup()
        local servers = {
          emmet_language_server = {
            filetypes = { "astro", "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact"},
            init_options = {
              ---@type table<string, string>
              includeLanguages = {},
              --- @type string[]
              excludeLanguages = {},
              --- @type string[]
              extensionsPath = {},
              --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
              preferences = {},
              --- @type boolean Defaults to `true`
              showAbbreviationSuggestions = true,
              --- @type "always" | "never" Defaults to `"always"`
              showExpandedAbbreviation = "always",
              --- @type boolean Defaults to `false`
              showSuggestionsAsSnippets = false,
              --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
              syntaxProfiles = {},
              --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
              variables = {},
            },
          },
          arduino_language_server = {},
          astro = {},
          bashls = {},
          clangd = {},
          dockerls = {},
          efm = {},
          golangci_lint_ls = {},
          gopls = {},
          html = { filetypes = { 'html', 'twig', 'hbs' } },
          jsonls = {},
          jsonnet_ls = {},
          lua_ls = { Lua = { workspace = { checkThirdParty = false }, telemetry = { enable = false }, }, },
          pyright = {},
          ruff = {},
          rust_analyzer = {},
          sqls = {},
          taplo = {},
          terraformls = {},
          tflint = {},
          ts_ls = {},
          yamlls = {},
        }

        -- Setup neovim lua configuration
        require('neodev').setup()

        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        -- Ensure the servers above are installed
        local mason_lspconfig = require 'mason-lspconfig'

        mason_lspconfig.setup {
          ensure_installed = vim.tbl_keys(servers),
        }

        local on_attach = function(_, bufnr)
          -- NOTE: Remember that lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself
          -- many times.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local nmap = function(keys, func, desc)
            if desc then
              desc = 'LSP: ' .. desc
            end

            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
          end

          nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- See `:help K` for why this keymap
          nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
          nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

          -- Lesser used LSP functionality
          nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
          nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
          nmap('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, '[W]orkspace [L]ist Folders')

          -- Create a command `:Format` local to the LSP buffer
          vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
            vim.lsp.buf.format()
          end, { desc = 'Format current buffer with LSP' })
        end

        mason_lspconfig.setup_handlers {
          function(server_name)
            require('lspconfig')[server_name].setup {
              capabilities = capabilities,
              on_attach = on_attach,
              settings = servers[server_name],
              filetypes = (servers[server_name] or {}).filetypes,
            }
          end,
        }

    -- -- document existing key chains
    -- require('which-key').register({
    --   ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
    --   ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
    --   -- ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
    --   ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
    --   ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
    --   ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
    --   ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
    -- })

    end
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      {
        "zbirenbaum/copilot-cmp",
        dependencies = { {"zbirenbaum/copilot.lua", opts = {}} },
        opts = {},
      },
      -- 'rafamadriz/friendly-snippets',
    },
    config = function()
        local cmp = require('cmp')

        local luasnip = require('luasnip')
        local ls = require("luasnip")
        local s = ls.snippet
        local t = ls.text_node
        ls.add_snippets('all', {
          s('hola', t 'hola mundo!')
        })

        ls.add_snippets('python', {
          s('pdb', t 'breakpoint()')
        })

        ls.add_snippets('python', {
          s('pm', t '__import__("pdb").pm()')
        })

        -- date
        ls.add_snippets('all', {
          s('date', t(os.date('%Y-%m-%d')))
        })

        ls.add_snippets('all', {
          s('time', t(os.date('%H:%M:%S')))
        })

        luasnip.config.setup({})

        cmp.setup({
          performance = {
            max_view_entries = 5,
          },
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert {
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            -- ['<C-l>'] = cmp.mapping.complete(),
            ['<C-l>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true, }),
          },
          sources = {
            { name = 'luasnip' },
            { name = 'nvim_lsp' },
            { name = "codeium" },
            { name = 'copilot' },
            { name = 'buffer' },
            { name = 'path' },
            per_filetype = {
              codecompanion = { "codecompanion" },
            },
            -- { name = 'nvim_lsp_signature_help' },
            -- { name = 'neorg' },
            -- { name = 'orgmode' },
          },
        })
    end
  },

  -- Useful plugin to show you pending keybinds.
  -- {
  --   'folke/which-key.nvim',
  --   opts = {},
  --   init = function()
  --     vim.opt.timeout = true
  --     require("which-key").setup({
  --       icons = {
  --         breadcrumb = ">>",
  --         separator = ">",
  --         group = "+",
  --       },
  --     })
  --   end,
  -- },

  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },


  -- {
  --   -- Adds git related signs to the gutter, as well as utilities for managing changes
  --   'lewis6991/gitsigns.nvim',
  --   opts = {
  --     -- See `:help gitsigns.txt`
  --     signs = {
  --       add = { text = '+' },
  --       change = { text = '~' },
  --       delete = { text = '_' },
  --       topdelete = { text = '‾' },
  --       changedelete = { text = '~' },
  --     },
  --     on_attach = function(bufnr)
  --       local gs = package.loaded.gitsigns
  --       vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })
  --       vim.keymap.set('n', '<leader>hs', gs.stage_hunk, {desc = 'Stage git hunk'})
  --       vim.keymap.set('n', '<leader>hr', gs.reset_hunk, {desc = 'Reset git hunk'})
  --       vim.keymap.set('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = 'Stage git hunk in visual mode'})
  --       vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = 'Reset git hunk in visual mode'})
  --       vim.keymap.set('n', '<leader>hS', gs.stage_buffer, {desc = 'Stage buffer'})
  --       vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, {desc = 'Undo stage git hunk'})
  --       vim.keymap.set('n', '<leader>hR', gs.reset_buffer, {desc = 'Reset buffer'})
  --       vim.keymap.set('n', '<leader>hp', gs.preview_hunk, {desc = 'Preview git hunk'})
  --       vim.keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc = 'Blame line full'} )
  --       vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, {desc = 'Toggle current line blame'})
  --       vim.keymap.set('n', '<leader>hd', gs.diffthis, {desc = 'Diff this'})
  --       vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end, {desc = 'Diff this with tilde'})
  --       vim.keymap.set('n', '<leader>td', gs.toggle_deleted, {desc = 'Toggle deleted'})
  --
  --       -- don't override the built-in and fugitive keymaps
  --       -- local gs = package.loaded.gitsigns
  --       vim.keymap.set({ 'n', 'v' }, ']c', function()
  --         if vim.wo.diff then
  --           return ']c'
  --         end
  --         vim.schedule(function()
  --           gs.next_hunk()
  --         end)
  --         return '<Ignore>'
  --       end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
  --       vim.keymap.set({ 'n', 'v' }, '[c', function()
  --         if vim.wo.diff then
  --           return '[c'
  --         end
  --         vim.schedule(function()
  --           gs.prev_hunk()
  --         end)
  --         return '<Ignore>'
  --       end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
  --     end,
  --   },
  -- },

  {
    'folke/tokyonight.nvim',
    priority = 1000, -- make sure to load this before all the other start plugins
    init = function()
      require("tokyonight").setup({
        style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        light_style = "day", -- The theme is used when the background is set to light
        transparent = true, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          functions = {},
          variables = {},
          sidebars = "transparent", -- style for sidebars, see below
          floats = "transparent", -- style for floating windows
        },
        sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
        day_brightness = 0.5, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
        hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
        dim_inactive = false, -- dims inactive windows
        lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
        on_colors = function(colors) end,
        on_highlights = function(highlights, colors) end,
      })
      -- vim.cmd.colorscheme 'tokyonight-night'
      -- vim.cmd.hi 'Comment gui=none'
    end,
  },

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    init = function()
      require('onedark').setup({
        term_colors = true,
        style = 'deep',
        -- toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between
        toggle_style_key = ',ts', -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
        transparent = true,       -- Show/hide background
        diagnostics = {
          darker = true,          -- darker colors for diagnostic
          undercurl = true,       -- use undercurl instead of underline for diagnostics
          background = false,     -- use background color for virtual text
        },
      })
    end,
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',   opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
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
      vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
      -- vim.keymap.set('n', '<leader>/', function()
      --   -- You can pass additional configuration to telescope to change theme, layout, etc.
      --   require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      --     winblend = 15,
      --     previewer = false,
      --   })
      -- end, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<C-p>',      require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
      vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', "<leader>fp", "<cmd>lua require('telescope.builtin').find_files( { cwd = vim.fn.expand('%:p:h'), hidden = false }) <CR>", { desc = "Search current buffer dir", noremap = true })
      vim.keymap.set('n', '<leader>fl', ':Telescope diagnostics<cr>', { noremap = true, desc = "Find errors, lint, diagnostics", silent = false })
      vim.keymap.set('n', '<leader>fc', ':Telescope commands<cr>', { noremap = true, desc = "Find commands", silent = false })
      vim.keymap.set('n', '<leader>fk', ':Telescope keymaps<cr>', { noremap = true, desc = "Find keymaps", silent = false })
      end
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'astro',   -- astro
        'c',
        'cpp',
        'go',
        'python',
        'lua',
        'rust',
        'tsx',   -- astro
        'javascript',
        'typescript',
        'vimdoc',
        'vim',
        'bash',
        'http',
        'html',
        'css',
        'csv',
        'json',
        'yaml',
        'markdown',
        'markdown_inline',
        'toml',
        'groovy',
        'terraform',
      },
      -- Autoinstall languages that are not installed
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },

  { import = 'custom.plugins' },
  { import = 'custom.settings' },
  { import = 'custom.plugins.runner' },

}, {})

-- [[ Setting options ]] {{{
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- search highlight
vim.opt.hlsearch = false
vim.opt.breakindent = true
vim.wo.number = true

-- vim.opt.foldmethod = 'marker'
-- vim.opt.foldmethod = 'syntax'
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.foldcolumn = "1"
vim.o.foldenable = false
-- vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldnestmax = 1
vim.o.foldmethod="expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true

-- }}}
--
-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]] {{{
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
-- }}}

-- Diagnostic keymaps {{{
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
-- }}}


-- [settings] {{{
function UseZsh()
  local handle = io.popen("which zsh")
  if handle == nil then
    return
  end
  local result = handle:read("*a")
  handle:close()

  if result ~= '' then
    -- Esto elimina los espacios en blanco
    vim.opt.shell = result:match("^%s*(.-)%s*$")
  end
end

-- TODO: why is this needed?
-- UseZsh()
-- }}}

vim.opt.splitright = true
vim.opt.splitbelow = true
-- vim.o.t_Co = 256
vim.opt.scrollback = 20000
-- vim.opt.guicursor=""
-- vim.opt.nohlsearch = true
-- vim.opt.hidden = true
-- vim.opt.noerrorbells = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = false
-- vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
-- vim.opt.noswapfile = true
-- vim.opt.nobackup = true
vim.opt.undodir = os.getenv("HOME") .. '/.vim/undodir'
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.scrolloff = 8
-- vim.opt.signcolumn='no'
vim.opt.cmdheight = 1
vim.opt.updatetime = 50
-- vim.opt.shortmess = vim.opt.shortmess .. 'c'
vim.opt.textwidth = 79
vim.opt.cursorline = true
vim.opt.colorcolumn = "80" -- works! (using integer will fail)
vim.opt.completeopt = 'menuone,noselect'
vim.g.netrw_hide = 0
vim.g.netrw_nogx = 1
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20
vim.opt.laststatus = 3
-- }}}

-- [[keymaps]] {{{
vim.keymap.set("i", "<C-e>", "<C-o>$", { noremap = true, silent = true, desc = "Move to end of line in insert mode" })
--
-- [[ fugitive ]] {{{
vim.keymap.set("n", "<leader>w", ":Git<cr>", { noremap = true, desc = "Open Git status" })
vim.keymap.set("n", "<leader>W", ":tab Git<cr>", { noremap = true, desc = "Open Git status in a new tab" })
vim.keymap.set('n', '<C-g>', ':GBrowse<cr>', { noremap = true, desc = 'browse current file on github' })
vim.keymap.set('v', '<C-g>', ':GBrowse<cr>', { noremap = true, desc = 'browse current file and line on github' })
vim.keymap.set('n', '<C-G>', ':GBrowse!<cr>', { noremap = true, desc = 'yank github url of the current file' })
vim.keymap.set('v', '<C-G>', ':GBrowse!<cr>', { noremap = true, desc = 'yank github url of the current line' })
-- }}}

-- terminal settings {{{
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { noremap = true, desc = "Switch to normal mode from terminal" })
vim.keymap.set('t', '<C-w>h', '<C-\\><C-n><C-w>h', { noremap = true, desc = "Move cursor to the left window" })
vim.keymap.set('t', '<C-w>j', '<C-\\><C-n><C-w>j', { noremap = true, desc = "Move cursor to the below window" })
vim.keymap.set('t', '<C-w>k', '<C-\\><C-n><C-w>k', { noremap = true, desc = "Move cursor to the above window" })
vim.keymap.set('t', '<C-w>l', '<C-\\><C-n><C-w>l', { noremap = true, desc = "Move cursor to the right window" })
vim.keymap.set('t', '<C-w>w', '<C-\\><C-n><C-w>w', { noremap = true, desc = "Switch to the next window" })
-- vim.keymap.set('t', '<C-P>', '<C-\\><C-n>pi<cr>', { noremap = true })
-- vim.keymap.set('n', '<C-l>', 'i<C-l>', {noremap = true})
-- }}}


-- [[ luasnip:snippets ]] {{{
-- }}}



-- [[ pdbrc ]] {{{
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
-- }}}

vim.keymap.set('n', 'bp', AddPdbrc, { noremap = true, silent = true, desc = 'Add pdbrc' })

-- escape
vim.keymap.set('i' , 'kj' , '<esc>'      , { noremap = true , silent = true, desc = 'Exit insert mode with kj' })
vim.keymap.set('i' , 'jk' , '<esc>'      , { noremap = true , silent = true, desc = 'Exit insert mode with jk' })

-- This doesn't work as expected
-- vim.keymap.set('t' , 'jk' , '<esc><esc>' , { noremap = true , silent = true, desc = 'Exit terminal mode with jk' })
-- vim.keymap.set('t' , 'kj' , '<esc><esc>' , { noremap = true , silent = true, desc = 'Exit terminal mode with kj' })


-- [shebang]
vim.keymap.set('n', '<leader>sh', ":mark m<cr>:0<cr>O#!/usr/bin/env bash<esc>'m:delm m<cr>", { desc = 'Add shebang line' })

-- [commands]
vim.keymap.set('n' , '<leader>xl', ':!<C-R><C-L>'  , { noremap = true, desc = 'Fill command with current line' })
vim.keymap.set('n' , '<leader>xc', ':.!sh '        , { noremap = true, desc = 'Fill command to execute current line in shell' })
vim.keymap.set('n' , '<leader>xr' , ':.!sh<cr>'    , { noremap = true , desc = 'E[X]ecute line in shell and [R]eplace with output' })
vim.keymap.set('v' , '<leader>xr' , ':!sh<cr>'     , { noremap = true , desc = 'E[X]ecute selection in shell and [R]eplace with output' })
vim.keymap.set('n' , '<leader>xs' , ':.w !sh<cr>'  , { noremap = true , desc = 'E[X]ecute line in shell and [S]how output' })
vim.keymap.set('v' , '<leader>xs' , ':w !sh<cr>'   , { noremap = true , desc = 'E[X]ecute selection in shell and [S]how output' })

-- Explore
-- vim.keymap.set('n', '-', ':Ex<cr>', { desc = "Open the current file's directory in the file explorer", silent = false })
vim.keymap.set('n', '<leader>-', ':Ex %:h<cr>', { desc = "Open the current file's directory in the file explorer", silent = false })

-- paste / yank / copy
vim.keymap.set('n' , '<leader>0'  , '"0p'                         , { desc = "Paste from register 0" , silent = false })
vim.keymap.set('n' , '<leader>9'  , '"1p'                         , { desc = "Paste from register 1" , silent = false })
vim.keymap.set('n' , '<leader>p'  , '"+p'                         , { desc = 'Paste clipboard register' })
vim.keymap.set('v' , '<leader>p'  , '"+p'                         , { desc = 'Paste clipboard register' })
vim.keymap.set('n' , '<leader>y'  , '"+yy'                        , { noremap = true                 , desc = 'copy to system clipboard' })
vim.keymap.set('v' , '<leader>y'  , '"+y'                         , { noremap = true                 , desc = 'copy to system clipboard' })
vim.keymap.set('n' , '<leader>yf' , ':let @+ = expand("%:p")<cr>' , { noremap = true                 , desc = 'yank filename path'})

-- [reload]
vim.keymap.set('n' , '<leader><cr>' , ':source ~/.config/nvim/init.lua<cr>' , { noremap = true })
vim.keymap.set('n' , '<leader>rc'   , ':vnew ~/.config/nvim/init.lua<cr>'   , { noremap = true })


-- replace in all file
-- vim.keymap.set('n', '<leader>s', ':s/<C-r><C-w>/<C-r><C-w>/gI<left><left><left>', { noremap = true, desc = 'search and replace word under cursor' })
vim.keymap.set('n', '<leader>s', ':%s/<C-r><C-w>/<C-r><C-w>/gI<left><left><left>', { noremap = true, desc = 'search and replace word under cursor' })
vim.keymap.set("n", "<leader>gw", ":grep '<C-R><C-W>'", { desc = "Find word using grep command" })

-- [move line]
vim.keymap.set('i' , '<C-k>'     , '<esc>:.m-2 | startinsert<cr>' , { noremap = true , desc = 'move line up' })
vim.keymap.set('i' , '<C-j>'     , '<esc>:.m+1 | startinsert<cr>' , { noremap = true , desc = 'move line down' })
vim.keymap.set('n' , '<leader>k' , ':m .-2<cr>=='                 , { noremap = true , desc = 'move line up' })
vim.keymap.set('n' , '<leader>j' , ':m .+1<cr>=='                 , { noremap = true , desc = 'move line down' })

-- [quickfix]
vim.keymap.set('n', '<leader>on', ':copen<cr>', { noremap = true, desc = 'open quickfix' })
vim.keymap.set('n', '<leader>cn', ':cnext<cr>', { noremap = true, desc = 'next error' })
vim.keymap.set('n', '<leader>cp', ':cprev<cr>', { noremap = true, desc = 'previous error' })


-- }}}


vim.cmd [[
augroup Latex
  au!
  au BufWritePost *.tex silent !dex pdflatex % && firefox %:t:r.pdf
augroup end
]]

-- terraform {{{
-- https://www.mukeshsharma.dev/2022/02/08/neovim-workflow-for-terraform.html
vim.cmd([[
augroup terraform
  autocmd!
  silent! autocmd! filetypedetect BufRead,BufNewFile *.tf
  autocmd BufRead,BufNewFile *.hcl set filetype=hcl
  autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl
  autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform
  autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json
augroup end
]])

-- vim.keymap.set("n", "<leader>ti", ":!terraform init<CR>", { noremap = true, desc = "Terraform init" })
-- vim.keymap.set("n", "<leader>tf", ":!terraform fmt %<CR>", { noremap = true, desc = "Terraform format" })
-- vim.keymap.set("n", "<leader>tv", ":!terraform validate<CR>", { noremap = true, desc = "Terraform validate" })
-- vim.keymap.set("n", "<leader>tp", ":!terraform plan<CR>", { noremap = true, desc = "Terraform plan" })
-- vim.keymap.set("n", "<leader>taa", ":!terraform apply -auto-approve<CR>", { noremap = true, desc = "Terraform apply auto approve" })
-- }}}



-- vim.cmd([[
--   " GoLang
--   augroup golang
--     autocmd!
--     autocmd BufRead go.mod setlocal filetype=go
--     autocmd BufWritePost go.mod silent !go mod tidy
--     autocmd BufWritePost *.go execute "silent !gofmt -w %" | execute "silent !goimports -w %" | execute "silent !golines -w %"
--   augroup END
-- ]])


-- if macos then
if vim.fn.has('mac') == 1 then
  vim.cmd([[
    augroup macos
      autocmd!
      autocmd BufWritePost yabairc !yabai --restart-service
      autocmd BufWritePost skhdrc !skhd --restart-service
    augroup END
  ]])
end

-- }}}



local function CurrentRelativePath()
  local current_file = vim.fn.expand('%:p')
  -- local current_directory = vim.fn.expand('%:p:h')
  local pwd = vim.fn.getcwd()
  return string.gsub(current_file, '^' .. pwd, '.')
end

-- function AirflowCpCmd()
--   local curren_file = CurrentRelativePath()
--   local cmd = 'gsutil cp -r '..current_file ..'gs://europe-west1-data-cloud-com-831c7a66-bucket/'..current_file
--   input = vim.fn.input('Command: ', cmd)
--   -- expand terminal command with the command
--   vim.api.nvim_cmd('terminal '..cmd)
-- end

vim.api.nvim_create_user_command('AirflowCp', '!echo gsutil cp -r % gs://europe-west1-data-cloud-com-831c7a66-bucket/%', {})

-- [[ Setting options ]] {{{
if vim.fn.has('mac') == 1 then
  vim.g.netrw_browsex_viewer = 'open'
else
  -- Set the default viewer for other operating systems
  vim.g.netrw_browsex_viewer = 'xdg-open'
end

-- }}}

-- [[ gist ]] {{{
if vim.fn.has('mac') == 1 then
  vim.g.gist_clip_command = 'pbcopy'
else
  vim.g.gist_clip_command = 'xclip -selection clipboard'
end
vim.g.gist_detect_filetype = 1
vim.g.gist_open_browser_after_post = 1
vim.g.gist_show_privates = 1
vim.g.gist_user = "asdf8601"
vim.g.gist_token = os.getenv('GH_GIST_TOKEN')
-- }}}



-- tag bar
vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }
vim.g.completion_enable_snippet = 'vim-vsnip'

vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, desc = 'Show Hover' })
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, desc = 'Rename' })
vim.keymap.set('n', '<leader>gd', ':lua vim.lsp.buf.definition()<CR>', { noremap = true, desc = 'Go to Definition' })
vim.keymap.set('n', '<leader>gi', ':lua vim.lsp.buf.implementation()<CR>', { noremap = true, desc = 'Go to Implementation' })
vim.keymap.set('n', '<leader>gh', ':lua vim.lsp.buf.signature_help()<CR>', { noremap = true, desc = 'Show Signature Help' })
vim.keymap.set('n', '<leader>gf', ':lua vim.lsp.buf.references()<CR>', { noremap = true, desc = 'Find References' })
vim.keymap.set('n', '<leader>ga', ':lua vim.lsp.buf.code_action()<CR>', { noremap = true, desc = 'Code Actions' })
vim.keymap.set('n', '<leader>dq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', { noremap = true, desc = 'Diagnostics Quickfix' })
vim.keymap.set('n', '<leader>dn', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true, desc = 'Go to Next Diagnostic' })
vim.keymap.set('n', '<leader>dp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap = true, desc = 'Go to Previous Diagnostic' })


-- vim.keymap.set('n', '<leader>sn', ':\'<,\'>!sort -n -k 2', { noremap = true, desc = 'sort lines numerically' })
-- vim.keymap.set('v', '<leader>s', ':\'<,\'>!sort -f<cr>', { noremap = true, desc = 'sort lines' })
-- vim.keymap.set('v', '<leader>sf', ':!sqlformat  -k upper -r --indent_after_first --indent_columns -<cr>', { noremap = true })
vim.keymap.set('v', '<leader>sf', ':!sqlfmt -<cr>', { noremap = true })

-- [markdown]
vim.keymap.set('n' , '<leader>tu'       , 'yypVr-'                   , { noremap = true , desc = 'underline word under cursor' })
vim.keymap.set('n' , '<leader>tx'       , ':s/\\[\\s\\?\\]/[x]/<cr>' , { noremap = true , desc = 'check a box in markdown' })
vim.keymap.set('n' , '<leader>t<space>' , ':s/\\[x\\]/[ ]/<cr>'      , { noremap = true , desc = 'uncheck a box in markdown' })
vim.keymap.set('n' , '<leader>ta'       , 'I- [ ] <esc>'             , { noremap = true , desc = 'append empty checkbox in markdown' })
vim.keymap.set('n' , '<leader>m'        , ':MaximizerToggle<cr>'     , { noremap = true , desc = 'Maximize current window' })

vim.keymap.set('n', '<leader>/', '/<C-r><C-w>', { desc = '[S]earch [R]esume' })

vim.keymap.set('n', '<leader>zz', '<cmd>ZenMode<cr>', { noremap = true, desc = 'ZenMode toggle' })
vim.keymap.set("v", "<leader>h", ":<c-u>HSHighlight 2<cr>", { noremap = true, desc = 'high-str' })
-- vim.keymap.set("n", "<leader>h", ":<c-u>HSHighlight 2<cr>", {noremap = true, desc = 'high-str'})

-- add python cells {{{
vim.keymap.set('n', '<leader>cO', 'O%%<esc>:norm gcc<cr>j', { noremap = true, desc = 'Insert a cell comment above the current line' })
vim.keymap.set('n', '<leader>co', 'o%%<esc>:norm gcc<cr>k', { noremap = true, desc = 'Insert a cell comment below the current line' })

vim.keymap.set('n', '<leader>c-', 'O<esc>80i-<esc>:norm gcc<cr>j', { noremap = true, desc = 'Insert a horizontal line of dashes above the current line' })
-- vim.keymap.set('n', 'vic', 'V?%%<cr>o/%%<cr>koj', { noremap = true, desc = 'Visually select a cell and insert a comment before and after it' })

-- }}}


-- file operations {{{
vim.keymap.set("n", "<leader>cd", ":lcd %:p:h<cr>", { noremap = true, silent = true, desc = "Change to the directory of the current file" })
vim.keymap.set('n', '<leader>fn', ":echo expand('%')<cr>", { noremap = true })
-- }}}

-- [[markdown]] {{{
vim.g.markdown_fenced_languages = { 'html', 'python', 'bash=sh', 'sql', 'mermaid' }
vim.g.markdown_minlines = 50
-- TODO: fill this
-- vim.g.mkdp_markdown_css = ''
vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 0
vim.g.mkdp_page_title = "${name}"
vim.g.mkdp_theme = 'light'
-- }}}

-- Create command to call jq '.' % and replace the buffer with the output {{{
-- vim.api.nvim_command('command! -buffer Jq %!jq "."')
vim.api.nvim_create_user_command('Jq', '%!jq', { nargs = 0 })
-- }}}

-- grep program {{{
if vim.fn.executable('rg') == 1 then
  vim.o.grepprg = 'rg --hidden --glob "!.git" --glob "!.venv" --vimgrep'
  vim.o.grepformat = '%f:%l:%c:%m'
else
  vim.print('ripgrep not found')
end
-- }}}
-- }}}


-- [[ autocomands ]] {{{
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
ASDF8601 = augroup('ASDF8601', { clear = true })

autocmd('BufWritePre', { group = ASDF8601, pattern = '*', command = '%s/\\s\\+$//e' })
autocmd('FileType', { group = ASDF8601, pattern = 'markdown', command = 'setl conceallevel=2 spl=en,es | TSBufDisable highlight' })
autocmd('FileType', { group = ASDF8601, pattern = 'make', command = 'setl noexpandtab shiftwidth=4 softtabstop=0' })
autocmd('TermOpen', { group = ASDF8601, pattern = '*', command = 'setl nonumber norelativenumber' })
autocmd('FileType', { group = ASDF8601, pattern = 'fugitive', command = 'setl nonumber norelativenumber' })
autocmd('FileType', { group = ASDF8601, pattern = 'python', command = 'nnoremap <buffer> <F8> :!black -l80 -S %<CR><CR>' })
autocmd('FileType', { group = ASDF8601, pattern = 'python', command = 'nnoremap <buffer> <F7> :!ruff check -l80 %<CR><CR>' })
autocmd('FileType', { group = ASDF8601, pattern = 'python', command = 'nnoremap <buffer> <F9> :!ruff check -l80 --fix %<CR><CR>' })
autocmd({ 'BufEnter', 'BufRead' }, { group = ASDF8601, pattern = 'Jenkinsfile', command = 'setl ft=groovy' })
autocmd({ 'BufEnter', 'BufRead' }, { group = ASDF8601, pattern = '*.astro', command = 'set ft=astro' })
autocmd({ 'BufEnter', 'BufRead' }, { group = ASDF8601, pattern = 'requirements*.txt', command = 'setl ft=requirements' })
autocmd('FileType', { group = ASDF8601, pattern = 'qf', callback = function() vim.keymap.set('n', 'q', ':cclose<cr>', { desc = 'close quickfix', buffer = true }) end })


-- local yank_group = augroup('HighlightYank', {})
autocmd({ "BufWritePre" }, {
  group = ASDF8601,
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

autocmd({ 'FileType' }, {
  group = ASDF8601,
  pattern = "dbui",
  command = "nmap <buffer> <leader>w <Plug>(DBUI_SaveQuery)",
})

vim.keymap.set('n', '<leader>sq', '<Plug>(DBUI_SaveQuery)', { noremap = true })

autocmd({ 'FileType' }, {
  group = ASDF8601,
  pattern = "markdown",
  command = "normal zR",
})


autocmd({ 'FileType' }, {
  group = ASDF8601,
  pattern = "dbui",
  command = "setl nonumber norelativenumber",
})

autocmd({ 'BufWritePost' }, {
  group = ASDF8601,
  pattern = "~/.Xresources",
  command = "silent !xrdb <afile> > /dev/null",
})

-- autocommand to automatically commit and push modifications on init.lua file using lua api
-- local Takt = vim.api.nvim_create_augroup('Takt', { clear = true })
-- autocmd({'BufWritePost',}, {
--   callback = function()
--     vim.cmd([[
--       !cd %:p:h && git commit -a -m 'Auto commit' &> /dev/null; git push &> /dev/null &
--     ]])
--   end,
--   group = Takt,
--   pattern = {'**/*takt*/*.csv'},
-- })

-- autocommand for WebDev {{{

-- [[ astro ]] {{{
vim.filetype.add({
  extension = {
    mdx = "mdx",
  },
})
vim.treesitter.language.register("markdown", "mdx") -- the mdx filetype will use the markdown parser and queries.
-- }}}

-- [[ JS ]]  {{{
local JS = vim.api.nvim_create_augroup('JS', { clear = true })

autocmd({'FileType',}, {
  callback = function()
    vim.cmd([[
      colorscheme onedark
    ]])
  end,
  group = JS,
  pattern = {'*.css', '*.js', '*.json', '*.html', '*.md', '*.astro'},
})

autocmd({'BufWritePost',}, {
  callback = function()
    vim.cmd([[
      silent execute('!npx prettier --write . --plugin=prettier-plugin-astro')
    ]])
  end,
  group = JS,
  pattern = {'*.css', '*.js', '*.json', '*.html', '*.md', '*.astro'},
})
-- }}}
-- }}}

-- commit and push on init.lua file using lua api {{{
-- local SyncVimRC = vim.api.nvim_create_augroup('SyncVimRC', { clear = true })
-- autocmd({'WinClosed', 'VimLeavePre', 'BufHidden', 'BufDelete'}, {
--   callback = function()
--     vim.cmd([[
--       !cd %:p:h && git commit -a -m 'Auto commit' &> /dev/null
--     ]])
--     vim.cmd([[
--       !git push &> /dev/null &
--     ]])
--   end,
--   group = SyncVimRC,
--   pattern = {'*/.config/nvim/*', '*/asdf8601/kickstart.nvim/*'},
-- })
-- }}}
-- }}}



-- [[ neovim-remote ]] {{{
-- if vim.fn.has('nvim') and vim.fn.executable("nvr") then
--   vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'
-- else
--   vim.print('nvr not found')
-- end
-- }}}


-- [[ colorschemes ]] {{{
vim.cmd.colorscheme 'modus-vivendi' -- not installed
-- vim.cmd.colorscheme 'tokyonight-night'
-- vim.cmd.colorscheme 'tokyonight-moon'
-- vim.cmd.colorscheme 'modus_vivendi'
-- vim.cmd.colorscheme 'onedark'
-- }}}



-- Run gofmt + goimports on save
-- local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*.go",
--   callback = function()
--     require('go.format').goimports()
--     require('go.format').gofmt()
--     require('go.format').org_imports()
--   end,
--   group = format_sync_grp,
-- })



-- vim: ts=2 sts=2 sw=2 et tw=0
