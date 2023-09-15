-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local executable = function(x)
  return vim.fn.executable(x) == 1
end

return {
  'sbulav/nredir.nvim',
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
    config = function()
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
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "NTBBloodbath/rest.nvim",
    enable = executable "jq",
    config = function()
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
    }
  },
  {
    "klen/nvim-test",
    config = function()
      require('nvim-test').setup({})
    end
  },
  {
    'jakewvincent/mkdnflow.nvim',
    rocks = 'luautf8', -- Ensures optional luautf8 dependency is installed
    config = function()
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
}
-- vim: ts=2 sts=2 sw=2 et tw=0
