-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local executable = function(x)
    return vim.fn.executable(x) == 1
end

return {
    {
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
    {
        'phaazon/mind.nvim',
        version = 'v2.2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        init = function()
            require 'mind'.setup()
        end
    },
    {
        'scalameta/nvim-metals',
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    'junegunn/vim-easy-align',
    'alec-gibson/nvim-tetris',
    {
        'kevinhwang91/nvim-bqf',
        dependencies = {
            'junegunn/fzf',
            -- init = function() vim.fn['fzf#install']() end,
        },
    },
    'nvim-telescope/telescope-symbols.nvim',
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
    {
        'simrat39/symbols-outline.nvim',
        init = function()
            require("symbols-outline").setup({
                show_symbol_details = true,
            })
        end
    },
    -- 'sbulav/nredir.nvim',
    -- 'tpope/vim-eunuch',
    -- 'tpope/vim-abolish', -- work with multiple cases of a word
    'tpope/vim-dadbod',
    'kristijanhusak/vim-dadbod-ui',
    -- 'tpope/vim-dispatch',
    'tpope/vim-fugitive', -- git wrapper
    'tpope/vim-obsession',
    -- 'tpope/vim-markdown',
    -- 'tpope/vim-repeat',
    'tpope/vim-rhubarb', -- github extension for fugitive
    'tpope/vim-speeddating',
    'tpope/vim-surround',
    'tpope/vim-unimpaired',
    -- 'tpope/vim-vinegar',
    'goerz/jupytext.vim',
    'ThePrimeagen/harpoon',
    'szw/vim-maximizer',
    'RRethy/vim-illuminate',
    'jpalardy/vim-slime',

    -- 'mhartington/formatter.nvim',
    {
        'stevearc/conform.nvim',
        opts = {},
        init = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    -- Conform will run multiple formatters sequentially
                    python = { "isort", "black -l79" },
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
            require("rest-nvim").setup()
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
    {
        'jakewvincent/mkdnflow.nvim',
        rocks = 'luautf8', -- Ensures optional luautf8 dependency is installed
        init = function()
            require('mkdnflow').setup({})
        end
    },
    { 'mracos/mermaid.vim' },
    { 'mzlogin/vim-markdown-toc', },
    {
        -- markdown preview
        'toppair/peek.nvim',
        build = 'deno task --quiet build:fast',
        init = function()
            require('peek').setup({
                auto_load = true,          -- whether to automatically load preview when
                -- entering another markdown buffer
                close_on_bdelete = true,   -- close preview window on buffer delete
                syntax = true,             -- enable syntax highlighting, affects performance
                theme = 'dark',            -- 'dark' or 'light'
                update_on_change = true,
                app = 'webview',           -- 'webview', 'browser', string or a table of strings
                -- explained below
                filetype = { 'markdown' }, -- list of filetypes to recognize as markdown
                -- relevant if update_on_change is true
                throttle_at = 200000,      -- start throttling when file exceeds this
                -- amount of bytes in size
                throttle_time = 'auto',    -- minimum amount of time in milliseconds
                -- that has to pass before starting new render
            })
        end
    },
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

    -- utils
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {}
    },
}
-- vim: ts=2 sts=2 sw=2 et tw=0
