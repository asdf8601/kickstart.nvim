-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local executable = function(x)
    return vim.fn.executable(x) == 1
end

return {
  -- {
  --   'nvim-treesitter/nvim-treesitter-context',
  --   init=function ()
  --     require('treesitter-context').setup({
  --       enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  --       max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  --       min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  --       line_numbers = true,
  --       multiline_threshold = 20, -- Maximum number of lines to show for a single context
  --       trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  --       mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  --       -- Separator between context and content. Should be a single character string, like '-'.
  --       -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  --       separator = nil,
  --       zindex = 20, -- The Z-index of the context window
  --       on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
  --     })
  --   end
  -- },
  -- {
  --   'ishan9299/modus-theme-vim',
  --   init = function ()
  --     vim.g.modus_yellow_comments = 0
  --     vim.g.modus_green_strings = 0
  --     vim.g.modus_faint_syntax = 0
  --     vim.g.modus_cursorline_intense = 1
  --     vim.g.modus_termtrans_enable = 1
  --     vim.g.modus_dim_inactive_window = 0
  --   end,
  -- },
  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,
    init = function ()
      require("modus-themes").setup({
        -- Theme comes in two styles `modus_operandi` and `modus_vivendi`
        -- `auto` will automatically set style based on background set with vim.o.background
        style = "auto",
        variant = "default", -- Theme comes in four variants `default`, `tinted`, `deuteranopia`, and `tritanopia`
        transparent = true, -- Transparent background (as supported by the terminal)
        dim_inactive = false, -- "non-current" windows are dimmed
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = false },
          keywords = { italic = false },
          functions = {},
          variables = {},
        },
      })
    end
  },
  {
    "Rawnly/gist.nvim",
    cmd = { "GistCreate", "GistCreateFromFile", "GistsList" },
    dependencies = {
      {
        "samjwill/nvim-unception",
        lazy = false,
        init = function() vim.g.unception_block_while_host_edits = true end
      },
    },
    init = function ()
      require("gist").setup({
        private = false, -- All gists will be private, you won't be prompted again
        clipboard = "+", -- The registry to use for copying the Gist URL
        list = {
          mappings = {
            next_file = "<C-n>",
            prev_file = "<C-p>"
          }
        }
      })

    end
  },
  {
    "robitx/gp.nvim",
    init = function()
      require("gp").setup()
      -- https://github.com/Robitx/gp.nvim?tab=readme-ov-file#4-configuration
    end,
  },
  {
    'echasnovski/mini.map',
    version = false,
    init = function()
      require('mini.map').setup(
        {
          integrations = nil,
          symbols = {
            encode = require('mini.map').gen_encode_symbols.dot('3x2'),
            scroll_line = '█',
            scroll_view = '┃',
          },
          window = {
            focusable = false,
            side = 'right',
            show_integration_count = true,
            width = 12,
            winblend = 25,
            zindex = 10,
          },
        }
      )
    end,
  },
  {
    "lunarVim/bigfile.nvim",
    opts = {},
  },
  {
    "windwp/nvim-ts-autotag",
    init = function()
      require('nvim-ts-autotag').setup()
    end
  },
  {
    "wuelnerdotexe/vim-astro",
  },
  {
    "virchau13/tree-sitter-astro",
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    -- Highlight text
    'Pocco81/HighStr.nvim',
    init = function()
      local high_str = require("high-str")
      high_str.setup({
        verbosity = 0,
        saving_path = "/tmp/highstr/",
        highlight_colors = {
          -- color_id = {"bg_hex_code",<"fg_hex_code"/"smart">}
          color_0 = { "#0c0d0e", "smart" },           -- Cosmic charcoal
          color_1 = { "#e5c07b", "smart" },           -- Pastel yellow
          color_2 = { "#7FFFD4", "smart" },           -- Aqua menthe
          color_3 = { "#8A2BE2", "smart" },           -- Proton purple
          color_4 = { "#FF4500", "smart" },           -- Orange red
          color_5 = { "#008000", "smart" },           -- Office green
          color_6 = { "#0000FF", "smart" },           -- Just blue
          color_7 = { "#FFC0CB", "smart" },           -- Blush pink
          color_8 = { "#FFF9E3", "smart" },           -- Cosmic latte
          color_9 = { "#7d5c34", "smart" },           -- Fallow brown
        }
      })
      vim.api.nvim_set_keymap("v", "<leader>h1", ":<c-u>HSHighlight 1<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "<leader>h2", ":<c-u>HSHighlight 2<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "<leader>h3", ":<c-u>HSHighlight 3<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "<leader>h4", ":<c-u>HSHighlight 4<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "<leader>h0", ":<c-u>HSRmHighlight<CR>", { noremap = true, silent = true })
    end
  },
  {
    -- scala lsp
    'scalameta/nvim-metals',
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      local metals_config = require("metals").bare_config()

      -- Example of settings
      metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      }

      -- metals_config.init_options.statusBarProvider = "on"
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
      local dap = require("dap")
      dap.configurations.scala = {
        {
          type = "scala",
          request = "launch",
          name = "RunOrTest",
          metals = {
            runType = "runOrTestFile",
            --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
          },
        },
        {
          type = "scala",
          request = "launch",
          name = "Test Target",
          metals = {
            runType = "testTarget",
          },
        },
      }

      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()
      end

      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end
  },

  'junegunn/vim-easy-align',
  'alec-gibson/nvim-tetris',

  {
    -- better quickfix
    'kevinhwang91/nvim-bqf',
    dependencies = {
      'junegunn/fzf',
      -- init = function() vim.fn['fzf#install']() end,
    },
  },

  {
    -- unix commands in vim
    'tpope/vim-eunuch',
  },
  {
    -- database support in vim
    'tpope/vim-dadbod',
    dependencies = {
      'kristijanhusak/vim-dadbod-ui',
    }
  },
  'tpope/vim-fugitive',   -- git wrapper
  'tpope/vim-obsession',
  'tpope/vim-repeat',     -- better repeat
  'tpope/vim-rhubarb',    -- github extension for fugitive
  'tpope/vim-speeddating',
  {
    -- better netrw
    'tpope/vim-vinegar',
  },
  'tpope/vim-unimpaired',
  'goerz/jupytext.vim',

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
  'szw/vim-maximizer',
  'RRethy/vim-illuminate',
  {
    'stevearc/conform.nvim',
    opts = {},
    init = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          -- Conform will run multiple formatters sequentially
          python = { "isort -m3", "black -l79", },
          -- Use a sub-list to run only the first available formatter
          javascript = { { "prettierd", "prettier" } },
          sh = { "beautysh" },
        },
      })
      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        require("conform").format({ async = true, lsp_fallback = true, range = range })
      end, { range = true })
    end
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      {
        "zbirenbaum/copilot-cmp",
        dependencies = { "copilot.lua" },
        init = function()
          require("copilot_cmp").setup()
        end,
      },
      {
        "zbirenbaum/copilot.lua",
        init = function()
          require('copilot').setup()
        end,
      },
    },
  },
  {
    "NTBBloodbath/rest.nvim",
    enable = executable "jq",
    init = function()
      require("rest-nvim").setup({
        -- Open request results in a horizontal split
        result_split_horizontal = true,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = false,
        -- stay in current windows (.http file) or change to results window (default)
        stay_in_current_window_after_split = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = true,
        -- Encode URL before making request
        encode_url = true,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          -- show the generated curl command in case you want to launch
          -- the same request via the terminal (can be verbose)
          show_curl_command = true,
          show_http_info = true,
          show_headers = true,
          -- table of curl `--write-out` variables or false if disabled
          -- for more granular control see Statistics Spec
          show_statistics = false,
          -- executables or functions for formatting response body [optional]
          -- set them to false if you want to disable them
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end
          },
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = '.env',
        custom_dynamic_variables = {},
        yank_dry_run = true,
        search_back = true,
      })
      vim.api.nvim_set_keymap("n", "<leader>rr", "<Plug>RestNvim", { noremap = true, silent = true })
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-vim-test",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim"
    },
    init = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG" },
            runner = "pytest",
            -- python = ".venv/bin/python",
          })
        }
      })
      vim.keymap.set('n', '<leader>tn', vim.cmd.TestNearest, { noremap = true, desc = 'Run nearest test' })
      vim.keymap.set('n', '<leader>tf', vim.cmd.TestFile, { noremap = true, desc = 'Run current file tests' })
      vim.keymap.set('n', '<leader>ts', vim.cmd.TestSuite, { noremap = true, desc = 'Run test suite' })
      vim.keymap.set('n', '<leader>tl', vim.cmd.TestLast, { noremap = true, desc = 'Run last test' })
      vim.keymap.set('n', '<leader>td', function() require("neotest").run.run({ strategy = "dap" }) end, { noremap = true, desc = 'Run test debug mode' })
    end
  },
  {
    "klen/nvim-test",
    init = function()
      require('nvim-test').setup({})
    end
  },
  { 'mracos/mermaid.vim' },
  { 'mzlogin/vim-markdown-toc', },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      'theHamsta/nvim-dap-virtual-text',
      'mfussenegger/nvim-dap-python',
      'leoluz/nvim-dap-go',
    },
    init = function()
      require("dapui").setup()
      require("dapui").setup()
      require("nvim-dap-virtual-text").setup({})
      require("dap-python").setup(os.getenv('HOME') .. '/.venv-nvim/bin/python')

      require('dap-go').setup({
        dap_configurations = {
          {
            -- Must be "go" or it will be ignored by the plugin
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
        delve = {
          path = "dlv",
          initialize_timeout_sec = 20,
          port = "${port}",
          args = {},
          build_flags = "",
        },
      })
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
      local dapui = require('dapui')
      vim.keymap.set('n', '<leader>du', dapui.toggle, { noremap = true, desc = 'toggle dap ui' })
      vim.keymap.set('n', '<leader>do', dapui.open, { noremap = true, desc = 'toggle dap ui' })
      vim.keymap.set('n', '<leader>dx', dapui.close, { noremap = true, desc = 'toggle dap ui' })
    end,
  },
  {
    'nvimdev/lspsaga.nvim',
    init = function()
      require('lspsaga').setup({
        symbol_in_winbar = {
          enable = true,
          separator = ' › ',
          hide_keyword = false,
          ignore_patterns = nil,
          show_file = true,
          folder_level = 1,
          color_mode = true,
          delay = 300,
        },
        outline = {
          win_position = 'right',
          win_width = 40,
          auto_preview = false,
          detail = false,
          auto_close = true,
          close_after_jump = false,
          layout = 'normal',
          max_height = 0.5,
          left_width = 0.3,
          keys = {
            toggle_or_jump = '<cr>',
            quit = 'q',
            jump = 'e',
          },
        },
        ui = {
          devicon = false,
          foldericon = true,
          -- expand = '[+]',
          -- collapse = '[-]',
          -- imp_sign = '[ ]',
          expand = '⊞ ',
          collapse = '⊟ ',
          imp_sign = '󰳛 ',
          code_action = "",
          lines = { '└', '├', '│', '─', '┌' },
          lightbulb = {
            enable = false,
            enable_in_insert = false,
            sign = false,
            sign_priority = 40,
            virtual_text = false,
          },
          kind = {
            Folder = { " " },
            Module = { " ", "@namespace" },
            Namespace = { " ", "@namespace" },
            Package = { " ", "@namespace" },
            Class = { " ", "@type" },
            Method = { " ", "@method" },
            Property = { " ", "LineNr" },
            Field = { " ", "@field" },
            Constructor = { " ", "@constructor" },
            Enum = { " ", "@type" },
            Interface = { " ", "@type" },
            Function = { " ", "@function" },
            Variable = { " ", "@constant" },
            Constant = { " ", "@constant" },
            String = { " ", "@string" },
            Number = { " ", "@number" },
            Boolean = { " ", "@boolean" },
            Array = { " ", "@constant" },
            Object = { " ", "@type" },
            Key = { " ", "@type" },
            Null = { "N ", "@type" },
            EnumMember = { " ", "@field" },
            Struct = { " ", "@type" },
            Event = { " ", "@type" },
            Operator = { " ", "@operator" },
            TypeParameter = { " ", "@parameter" },
            Parameter = { " ", "@parameter" },
          },
        },
      })
      vim.keymap.set('n', '<leader>t', ':Lspsaga outline<cr>', { desc = "Symbols outline", silent = false })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
    }
  },

  {
    'echasnovski/mini.files',
    init = function ()
      require('mini.files').setup({
        options = {
          permanent_delete = false,
          use_as_default_explorer = false,
        },
        mappings = {
            close       = 'q',
            go_in       = 'l',
            go_in_plus  = 'L',
            go_out      = 'h',
            go_out_plus = 'H',
            reset       = '<C-r>',
            reveal_cwd  = '@',
            show_help   = 'g?',
            synchronize = '=',
            trim_left   = '<',
            trim_right  = '>',
          },
        windows = {
          max_number = math.huge,
          preview = false,
          width_focus = 50,
          width_nofocus = 15,
          width_preview = 25,
        },

      })
    end,
    version = '*',
  },
  {
    -- work with multiple cases of a word
    -- :%Subvert/facilit{y,ies}/building{,s}/g
    'tpope/vim-abolish',
  },
  {
    -- Spawning interactive processes
    'tpope/vim-dispatch',
  },
  {
    'tpope/vim-markdown',
  },

  -- {
  --   NOTE: this was causing lost the startup message
  --   "ray-x/go.nvim",
  --   dependencies = {     -- optional packages
  --     "ray-x/guihua.lua",
  --     "neovim/nvim-lspconfig",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   init = function()
  --     require("go").setup()
  --     local go_utils = vim.api.nvim_create_augroup("GoImport", {})
  --     vim.api.nvim_create_autocmd("BufWritePre", {
  --       pattern = "*.go",
  --       callback = function()
  --        require('go.format').goimport()
  --       end,
  --       group = go_utils,
  --     })
  --   end,
  --   event = { "CmdlineEnter" },
  --   ft = { "go", 'gomod' },
  --   build = ':lua require("go.install").update_all_sync()'     -- if you need to install/update all binaries
  -- },
  -- {
  --     NOTE: this was causing lost the startup message
  --     "kylechui/nvim-surround",
  --     version = "*", -- Use for stability; omit to use `main` branch for the latest features
  --     event = "VeryLazy",
  --     init = function()
  --         require("nvim-surround").setup({
  --             -- Configuration here, or leave empty to use defaults
  --             keymaps = {
  --                 insert = "<C-g>s",
  --                 insert_line = "<C-g>S",
  --                 normal = "ys",
  --                 normal_cur = "yss",
  --                 normal_line = "yS",
  --                 normal_cur_line = "ySS",
  --                 visual = "S",
  --                 visual_line = "gS",
  --                 delete = "ds",
  --                 change = "cs",
  --             },
  --         })
  --     end
  -- },


    -- utils
    -- {
    --     don't know why but this plugin removes the startup message of neovim
    --     "folke/todo-comments.nvim",
    --     dependencies = { "nvim-lua/plenary.nvim" },
    --     opts = {}
    -- },
    -- 'mhartington/formatter.nvim',
    -- chatgpt
    -- {
    --     "jackMort/ChatGPT.nvim",
    --     dependencies = {
    --         "MunifTanjim/nui.nvim",
    --         "nvim-lua/plenary.nvim",
    --         "nvim-telescope/telescope.nvim",
    --     },
    --     init = function()
    --         require("chatgpt").setup({
    --             openai_params = {
    --                 model = "gpt-4",
    --                 frequency_penalty = 0,
    --                 presence_penalty = 0,
    --                 max_tokens = 300,
    --                 temperature = 0,
    --                 top_p = 1,
    --                 n = 1,
    --             },
    --             -- openai_edit_params = {
    --             --   model = "code-davinci-edit-001",
    --             --   temperature = 0,
    --             --   top_p = 1,
    --             --   n = 1,
    --             -- },
    --             chat = {
    --                 keymaps = {
    --                     close = { "<C-c>", },
    --                     yank_last = "<C-y>",
    --                     scroll_up = "<C-u>",
    --                     scroll_down = "<C-d>",
    --                     toggle_settings = "<C-o>",
    --                     new_session = "<C-n>",
    --                     cycle_windows = "<Tab>",
    --                 },
    --             },
    --             popup_input = {
    --                 submit = "<C-s>",
    --             },
    --         })
    --     end,
    -- },
    -- {
    --     "dpayne/CodeGPT.nvim",
    --     dependencies = {
    --         "MunifTanjim/nui.nvim",
    --         "nvim-lua/plenary.nvim",
    --     },
    --     init = function()
    --         require("codegpt.config")
    --     end
    -- },
    -- {
    --     "nvim-treesitter/nvim-treesitter-context",
    -- },
    -- {
    --   "SmiteshP/nvim-navic",
    --   init = function()
    --     local navic = require("nvim-navic")
    --
    --     require("lspconfig").pyright.setup {
    --       on_attach = function(client, bufnr)
    --         navic.attach(client, bufnr)
    --       end
    --     }
    --   end
    -- },
    -- 'tyru/open-browser.vim',
    -- { 'github/copilot.vim' },
    -- 'nvim-telescope/telescope-symbols.nvim',
    -- {
    --     'simrat39/symbols-outline.nvim',
    --     init = function()
    --         require("symbols-outline").setup({
    --             show_symbol_details = true,
    --         })
    --     end
    -- },
    -- {
    --     "ludovicchabant/vim-gutentags",
    -- },
    -- 'sbulav/nredir.nvim',
    -- 'tpope/vim-surround',

}
-- vim: ts=2 sts=2 sw=2 et tw=0
