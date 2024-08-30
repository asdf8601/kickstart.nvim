-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
---@diagnostic disable: undefined-field
local executable = function(x)
    return vim.fn.executable(x) == 1
end

return {

  {
    'MeanderingProgrammer/markdown.nvim',
    name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('render-markdown').setup({
        headings = { '#', '#', '#', '#', '#', '#' },
        bullet = '○',
      })
    end,
  },

  {
    'laytan/cloak.nvim',
    config=function()
      require('cloak').setup({
        enabled = true,
        cloak_character = '*',
        highlight_group = 'Comment',
        cloak_length = nil,
        try_all_patterns = true,
        cloak_telescope = true,
        patterns = {
          {
            file_pattern = {'.autoenv', '.env*'},
            cloak_pattern = '=.+',
            replace = nil,
          },
        },
      })
    end
  },

  {
    'nvim-pack/nvim-spectre',
    config=function ()
      require('spectre').setup()
      vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
      vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = "Search current word" })
      vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = "Search current word" })
      vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = "Search on current file" })
    end,

    dependencies = {'nvim-lua/plenary.nvim'}
  },

  {
    -- foldings
    "chrisgrieser/nvim-origami",
    event = "BufReadPost", -- later or on keypress would prevent saving folds
    opts = true, -- needed even when using default config
  },

  {
    'ishan9299/modus-theme-vim',
    config = function ()
      vim.g.modus_yellow_comments = 0
      vim.g.modus_green_strings = 0
      vim.g.modus_faint_syntax = 0
      vim.g.modus_cursorline_intense = 1
      vim.g.modus_termtrans_enable = 1
      vim.g.modus_dim_inactive_window = 0
    end,
  },

  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,
    config = function ()
      require("modus-themes").setup({
        -- Theme comes in two styles `modus_operandi` and `modus_vivendi`
        -- `auto` will automatically set style based on background set with vim.o.background
        style = "modus_vivendi",
        variant = "tinted", -- Theme comes in four variants `default`, `tinted`, `deuteranopia`, and `tritanopia`
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
        on_colors = function(colors)
            colors.error = colors.red_faint
        end,
        on_highlights = function(hl, c)
        end,
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
        config = function() vim.g.unception_block_while_host_edits = true end
      },
    },
    config = function ()
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
    lazy = false,
    config = function()

      require("gp").setup({
        providers = {
          ollama = {
            endpoint = "http://localhost:11434/v1/chat/completions",
          },
        },

        agents = {
          {
            name = "Llama3",
            chat = true,
            command = true,
            provider = "ollama",
            model = { model = "llama3", stream = false },
            system_prompt = "Your are a general AI assistant better than ChatGPT4.",
          },
          {
            name = "ChatGPT4",
            chat = true,
            command = false,
            model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "You are a general AI assistant.\n\n"
              .. "The user provided the additional info about how they would like you to respond:\n\n"
              .. "- If you're unsure don't guess and say you don't know instead.\n"
              .. "- Ask question if you need clarification to provide better answer.\n"
              .. "- Think deeply and carefully from first principles step by step.\n"
              .. "- Zoom out first to see the big picture and then zoom in to details.\n"
              .. "- Use Socratic method to improve your thinking and coding skills.\n"
              .. "- Don't elide any code from your output if the answer requires coding.\n"
              .. "- Take a deep breath; You've got this!\n",
          },
          {
            name = "ChatGPT3-5",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-3.5-turbo", temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "You are a general AI assistant.\n\n"
              .. "The user provided the additional info about how they would like you to respond:\n\n"
              .. "- If you're unsure don't guess and say you don't know instead.\n"
              .. "- Ask question if you need clarification to provide better answer.\n"
              .. "- Think deeply and carefully from first principles step by step.\n"
              .. "- Zoom out first to see the big picture and then zoom in to details.\n"
              .. "- Use Socratic method to improve your thinking and coding skills.\n"
              .. "- Don't elide any code from your output if the answer requires coding.\n"
              .. "- Take a deep breath; You've got this!\n",
          },
          {
            name = "CodeGPT4",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o", temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "You are an AI working as a code editor.\n\n"
              .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
              .. "START AND END YOUR ANSWER WITH:\n\n```",
          },
          {
            name = "CodeGPT3-5",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-3.5-turbo", temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "You are an AI working as a code editor.\n\n"
              .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
              .. "START AND END YOUR ANSWER WITH:\n\n```",
          },

        },
      })
      -- https://github.com/Robitx/gp.nvim?tab=readme-ov-file#4-configuration
    end,
  },

  {
    "lunarVim/bigfile.nvim",
    opts = {},
  },

  {
    "windwp/nvim-ts-autotag",
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    config=function()

      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      -- vim.o.foldenable = true

      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return {'treesitter', 'indent'}
        end
      })
    end,

  },

  {
    -- astro
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
    config = function()
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

      vim.api.nvim_set_keymap("v", "<leader>h1", ":<c-u>HSHighlight 1<CR>", { noremap = true, silent = true, desc = "Highlight text with color 1"})
      vim.api.nvim_set_keymap("v", "<leader>h2", ":<c-u>HSHighlight 2<CR>", { noremap = true, silent = true, desc = "Highlight text with color 2"})
      vim.api.nvim_set_keymap("v", "<leader>h3", ":<c-u>HSHighlight 3<CR>", { noremap = true, silent = true, desc = "Highlight text with color 3"})
      vim.api.nvim_set_keymap("v", "<leader>h4", ":<c-u>HSHighlight 4<CR>", { noremap = true, silent = true, desc = "Highlight text with color 4"})
      vim.api.nvim_set_keymap("v", "<leader>h0", ":<c-u>HSRmHighlight<CR>", { noremap = true, silent = true, desc = "Remove text highlight"})

    end
  },

  {
    -- scala lsp
    'scalameta/nvim-metals',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
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
      -- config = function() vim.fn['fzf#install']() end,
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
  'tpope/vim-obsession',
  'tpope/vim-repeat',     -- better repeat
  'tpope/vim-speeddating',
  {
    -- better netrw
    'tpope/vim-vinegar',
  },

  {
    'tpope/vim-unimpaired',
  },

  {
    'goerz/jupytext.vim',
    config=function ()
      vim.g.jupytext_fmt = 'py:percent'
    end
  },

  'szw/vim-maximizer',
  'RRethy/vim-illuminate',

  {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
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
    "NTBBloodbath/rest.nvim",
    enable = executable "jq",
    ft = { "http" },
    dependencies = {
      {
        "vhyrro/luarocks.nvim",
        priority = 1000,
        config = true,
      },
    },
    config = function()
      require("rest-nvim").setup({
        client = "curl",
        env_file = ".env",
        env_pattern = "\\.env$",
        env_edit_command = "tabedit",
        encode_url = true,
        skip_ssl_verification = false,
        custom_dynamic_variables = {},
        logs = {
          level = "info",
          save = true,
        },
        result = {
          split = {
            horizontal = false,
            in_place = false,
            stay_in_current_window_after_split = true,
          },
          behavior = {
            decode_url = true,
            show_info = {
              url = true,
              headers = true,
              http_info = true,
              curl_command = true,
            },
            statistics = {
              enable = true,
              ---@see https://curl.se/libcurl/c/curl_easy_getinfo.html
              stats = {
                { "total_time", title = "Time taken:" },
                { "size_download_t", title = "Download size:" },
              },
            },
            formatters = {
              json = "jq",
              html = function(body)
                if vim.fn.executable("tidy") == 0 then
                  return body, { found = false, name = "tidy" }
                end
                local fmt_body = vim.fn.system({
                  "tidy",
                  "-i",
                  "-q",
                  "--tidy-mark",      "no",
                  "--show-body-only", "auto",
                  "--show-errors",    "0",
                  "--show-warnings",  "0",
                  "-",
                }, body):gsub("\n$", "")

                return fmt_body, { found = true, name = "tidy" }
              end,
            },
          },
        },
        highlight = {
          enable = true,
          timeout = 750,
        },
        ---@see vim.keymap.set
        keybinds = {
          {
            "<localleader>rr", ":Rest run", "Run request under the cursor",
          },
          {
            "<localleader>rl", ":Rest run last", "Re-run latest request",
          },
        },
      })
      -- vim.api.nvim_set_keymap("n", "<leader>rr", "<Plug>RestNvim", { noremap = true, silent = true })
    end,
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-vim-test",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
    },
    init = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            dap = { justMyCode = false },
            args = { "--capture", "no" },
            runner = "pytest",
            -- python = ".venv/bin/python",

          }),
        -- log_level = vim.log.levels.DEBUG,
        }
      })
    end,
    config = function ()
      vim.keymap.set('n', '<leader>tn', function() require("neotest").run.run() end, { noremap = true, desc = 'Run nearest test' })
      vim.keymap.set('n', '<leader>tf', function() require("neotest").run.run(vim.fn.expand("%")) end, { noremap = true, desc = 'Run current file tests' })
      vim.keymap.set('n', '<leader>to', function() require("neotest").output_panel.toggle() end, { noremap = true, desc = 'Toggle output panel' })
      vim.keymap.set('n', '<leader>tl', function() require("neotest").run.run_last() end, { noremap = true, desc = 'Run last test' })
      vim.keymap.set('n', '<leader>td', function() require("neotest").run.run({ strategy = "dap" }) end, { noremap = true, desc = 'Run test debug mode' })
    end
  },

  -- {
  --   "klen/nvim-test",
  --   config = function()
  --     require('nvim-test').setup({})
  --   end
  -- },

  { 'mracos/mermaid.vim' },

  { 'mzlogin/vim-markdown-toc', },

  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    config = function() vim.g.mkdp_filetypes = { "markdown" } end,
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
    config = function()
      require("dapui").setup()
      require("dapui").setup()
      require("nvim-dap-virtual-text").setup({})
      require("dap-python").setup(os.getenv('HOME') .. '/.venv-nvim/bin/python')

      require('dap-go').setup({
        dap_configurations = {
          {
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
    config = function()
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

  {
    -- NOTE: this was causing lost the startup message
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()'
  },

}
-- vim: ts=2 sts=2 sw=2 et tw=0
