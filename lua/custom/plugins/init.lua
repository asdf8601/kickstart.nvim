-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local executable = function(x)
  return vim.fn.executable(x) == 1
end

return {
  'alec-gibson/nvim-tetris',
  {
    'kevinhwang91/nvim-bqf',
    dependencies = {
      'junegunn/fzf',
      init = function() vim.fn['fzf#install']() end,
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
  'mzlogin/vim-markdown-toc',
  {
    'simrat39/symbols-outline.nvim',
    init = function()
      require("symbols-outline").setup({
          show_symbol_details = true,
      })
    end
  },
  'sbulav/nredir.nvim',
  'tpope/vim-eunuch',
  'tpope/vim-abolish',
  'tpope/vim-dadbod',
  'kristijanhusak/vim-dadbod-ui',
  'tpope/vim-dispatch',
  'tpope/vim-fugitive',
  'tpope/vim-markdown',
  'tpope/vim-obsession',
  'tpope/vim-repeat',
  'tpope/vim-rhubarb',
  'tpope/vim-speeddating',
  'tpope/vim-surround',
  'tpope/vim-unimpaired',
  'tpope/vim-vinegar',
  'goerz/jupytext.vim',
  'ThePrimeagen/harpoon',
  'szw/vim-maximizer',
  'RRethy/vim-illuminate',
  'jpalardy/vim-slime',
  'mhartington/formatter.nvim',
  'tyru/open-browser.vim',
  {
    "zbirenbaum/copilot.lua",
    init = function()
      require('copilot').setup()
    end,
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline' },
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
    init = function ()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            dap = { justMyCode = false },
            args = {"--log-level", "DEBUG"},
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
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
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
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
}
-- vim: ts=2 sts=2 sw=2 et tw=0
