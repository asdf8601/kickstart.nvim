-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local executable = function(x)
    return vim.fn.executable(x) == 1
end

return {
  { 'echasnovski/mini.nvim', version = false },

  {
    "windwp/nvim-ts-autotag",
    init=function ()
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
                    color_0 = { "#0c0d0e", "smart" }, -- Cosmic charcoal
                    color_1 = { "#e5c07b", "smart" }, -- Pastel yellow
                    color_2 = { "#7FFFD4", "smart" }, -- Aqua menthe
                    color_3 = { "#8A2BE2", "smart" }, -- Proton purple
                    color_4 = { "#FF4500", "smart" }, -- Orange red
                    color_5 = { "#008000", "smart" }, -- Office green
                    color_6 = { "#0000FF", "smart" }, -- Just blue
                    color_7 = { "#FFC0CB", "smart" }, -- Blush pink
                    color_8 = { "#FFF9E3", "smart" }, -- Cosmic latte
                    color_9 = { "#7d5c34", "smart" }, -- Fallow brown
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
        "ray-x/go.nvim",
        dependencies = { -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup()
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
    -- {
    --     'phaazon/mind.nvim',
    --     version = 'v2.2',
    --     dependencies = { 'nvim-lua/plenary.nvim' },
    --     init = function()
    --         require('mind').setup()
    --     end
    -- },
    {
        -- scala lsp
        'scalameta/nvim-metals',
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    'junegunn/vim-easy-align',
    'alec-gibson/nvim-tetris',

    -- better quick fix
    {
        -- better quickfix
        'kevinhwang91/nvim-bqf',
        dependencies = {
            'junegunn/fzf',
            -- init = function() vim.fn['fzf#install']() end,
        },
    },

    -- 'nvim-telescope/telescope-symbols.nvim',
    -- {
    --   'edluffy/hologram.nvim',
    --   init = function ()
    --     require('hologram').setup{
    --       auto_display = true -- WIP automatic markdown image display, may be prone to breaking
    --     }
    --   end
    -- },
    -- {
    --   'nvim-telescope/telescope-media-files.nvim',
    --   init = function()
    --     require('telescope').setup({
    --       extensions = {
    --         media_files = {
    --           -- filetypes whitelist
    --           -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
    --           filetypes = {"png", "webp", "jpg", "jpeg"},
    --           -- find command (defaults to `fd`)
    --           find_cmd = "rg"
    --         }
    --       },
    --     })
    --   end
    -- },
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

    {
        -- unix commands in vim
        'tpope/vim-eunuch',
    },

    {
        -- database support in vim
        'tpope/vim-dadbod',
    },
    'kristijanhusak/vim-dadbod-ui',
    'tpope/vim-fugitive', -- git wrapper
    'tpope/vim-obsession',
    'tpope/vim-repeat', -- better repeat
    'tpope/vim-rhubarb', -- github extension for fugitive
    'tpope/vim-speeddating',
    -- {
    --     -- work with multiple cases of a word
    --     -- :%Subvert/facilit{y,ies}/building{,s}/g
    --     'tpope/vim-abolish',
    -- },
    {
        -- better netrw
        'tpope/vim-vinegar',
    },
    -- {
    --     -- Spawning interactive processes
    --     'tpope/vim-dispatch',
    -- },
    -- 'tpope/vim-markdown',
    -- 'sbulav/nredir.nvim',

    -- 'tpope/vim-surround',
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
                keymaps = {
                    insert = "<C-g>s",
                    insert_line = "<C-g>S",
                    normal = "ys",
                    normal_cur = "yss",
                    normal_line = "yS",
                    normal_cur_line = "ySS",
                    visual = "S",
                    visual_line = "gS",
                    delete = "ds",
                    change = "cs",
                },
            })
        end
    },
    'tpope/vim-unimpaired',
    'goerz/jupytext.vim',
    'ThePrimeagen/harpoon',
    'szw/vim-maximizer',
    'RRethy/vim-illuminate',
    -- 'mhartington/formatter.nvim',
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
    -- 'tyru/open-browser.vim',
    {
        "zbirenbaum/copilot.lua",
        init = function()
            require('copilot').setup()
        end,
    },
    -- { 'github/copilot.vim' },
    {
        'hrsh7th/nvim-cmp',
        dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip', 'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline' },
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "copilot.lua" },
        init = function()
            require("copilot_cmp").setup()
        end,
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
            skip_ssl_verification = false,
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
                  return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
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
        end
    },
    {
        "klen/nvim-test",
        init = function()
            require('nvim-test').setup({})
        end
    },
    -- {
    --     'jakewvincent/mkdnflow.nvim',
    --     rocks = 'luautf8', -- Ensures optional luautf8 dependency is installed
    --     init = function()
    --         require('mkdnflow').setup({})
    --     end
    -- },
    { 'mracos/mermaid.vim' },
    { 'mzlogin/vim-markdown-toc', },
    -- {
    --     -- markdown preview
    --     'toppair/peek.nvim',
    --     build = 'deno task --quiet build:fast',
    --     init = function()
    --         require('peek').setup({
    --             auto_load = true,          -- whether to automatically load preview when
    --             -- entering another markdown buffer
    --             close_on_bdelete = true,   -- close preview window on buffer delete
    --             syntax = true,             -- enable syntax highlighting, affects performance
    --             theme = 'dark',            -- 'dark' or 'light'
    --             update_on_change = true,
    --             app = 'brave-browser',           -- 'webview', 'browser', string or a table of strings
    --             -- explained below
    --             filetype = { 'markdown' }, -- list of filetypes to recognize as markdown
    --             -- relevant if update_on_change is true
    --             throttle_at = 200000,      -- start throttling when file exceeds this
    --             -- amount of bytes in size
    --             throttle_time = 'auto',    -- minimum amount of time in milliseconds
    --             -- that has to pass before starting new render
    --         })
    --     end
    -- },
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
        }
    },

    -- chatgpt
    {
        "jackMort/ChatGPT.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        init = function()
            require("chatgpt").setup({
                openai_params = {
                    model = "gpt-4",
                    frequency_penalty = 0,
                    presence_penalty = 0,
                    max_tokens = 300,
                    temperature = 0,
                    top_p = 1,
                    n = 1,
                },
                -- openai_edit_params = {
                --   model = "code-davinci-edit-001",
                --   temperature = 0,
                --   top_p = 1,
                --   n = 1,
                -- },
                chat = {
                    keymaps = {
                        close = { "<C-c>", },
                        yank_last = "<C-y>",
                        scroll_up = "<C-u>",
                        scroll_down = "<C-d>",
                        toggle_settings = "<C-o>",
                        new_session = "<C-n>",
                        cycle_windows = "<Tab>",
                    },
                },
                popup_input = {
                    submit = "<C-s>",
                },
            })
        end,
    },
    {
        "dpayne/CodeGPT.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
        },
        init = function()
            require("codegpt.config")
        end
    },
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

  {
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup({
        ui = {
          devicon = false,
          foldericon = true,
          code_action = "",
          lightbulb = {
            enable = false,
            enable_in_insert = false,
            sign = false,
            sign_priority = 40,
            virtual_text = false,
          },
          kind = {
              -- disable all icons

              -- Folder = { "" },
              Module = { "", "@namespace" },
              Namespace = { "", "@namespace" },
              Package = { "", "@namespace" },
              Class = { "", "@type" },
              Method = { "", "@method" },
              Property = { "", "LineNr" },
              Field = { "", "@field" },
              Constructor = { "", "@constructor" },
              Enum = { "", "@type" },
              Interface = { "", "@type" },
              Function = { "", "@function" },
              Variable = { "", "@constant" },
              Constant = { "", "@constant" },
              String = { "", "@string" },
              Number = { "", "@number" },
              Boolean = { "", "@boolean" },
              Array = { "", "@constant" },
              Object = { "", "@type" },
              Key = { "", "@type" },
              Null = { "", "@type" },
              EnumMember = { "", "@field" },
              Struct = { "", "@type" },
              Event = { "", "@type" },
              Operator = { "", "@operator" },
              TypeParameter = { "", "@parameter" },
              Parameter = { "", "@parameter" },

              -- Folder = { " " },
              -- Module = { " ", "@namespace" },
              -- Namespace = { " ", "@namespace" },
              -- Package = { " ", "@namespace" },
              -- Class = { " ", "@type" },
              -- Method = { " ", "@method" },
              -- Property = { " ", "LineNr" },
              -- Field = { " ", "@field" },
              -- Constructor = { " ", "@constructor" },
              -- Enum = { " ", "@type" },
              -- Interface = { " ", "@type" },
              -- Function = { " ", "@function" },
              -- Variable = { " ", "@constant" },
              -- Constant = { " ", "@constant" },
              -- String = { " ", "@string" },
              -- Number = { "󰎠 ", "@number" },
              -- Boolean = { " ", "@boolean" },
              -- Array = { " ", "@constant" },
              -- Object = { " ", "@type" },
              -- Key = { " ", "@type" },
              -- Null = { "󰟢 ", "@type" },
              -- EnumMember = { " ", "@field" },
              -- Struct = { " ", "@type" },
              -- Event = { "󱐋 ", "@type" },
              -- Operator = { " ", "@operator" },
              -- TypeParameter = { " ", "@parameter" },
              -- Parameter = { " ", "@parameter" },
          },
        },
      })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      -- 'nvim-tree/nvim-web-devicons',     -- optional
    }
  },


    -- utils
    -- {
    --     don't know why but this plugin removes the startup message of neovim
    --     "folke/todo-comments.nvim",
    --     dependencies = { "nvim-lua/plenary.nvim" },
    --     opts = {}
    -- },
}
-- vim: ts=2 sts=2 sw=2 et tw=0
