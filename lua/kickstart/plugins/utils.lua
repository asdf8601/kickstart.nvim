-- Big file guard: replaces the unmaintained lunarVim/bigfile.nvim
local bigfile_size = 1.5 * 1024 * 1024
local bigfile_line_len = 10000
local bigfile_group = vim.api.nvim_create_augroup('bigfile_guard', { clear = true })

local function bigfile_disable(buf)
  vim.b[buf].bigfile = true
  vim.bo[buf].swapfile = false
  vim.bo[buf].undofile = false
  vim.api.nvim_buf_call(buf, function()
    vim.opt_local.foldmethod = 'manual'
    vim.opt_local.foldenable = false
  end)
end

local function bigfile_disable_highlight(buf)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  pcall(vim.treesitter.stop, buf)
  vim.bo[buf].syntax = 'off'
  vim.api.nvim_buf_call(buf, function()
    vim.opt_local.foldmethod = 'manual'
    vim.opt_local.foldenable = false
  end)
end

vim.api.nvim_create_autocmd('BufReadPre', {
  group = bigfile_group,
  desc = 'Disable heavy features for big files',
  callback = function(args)
    local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(args.buf))
    if size > bigfile_size then bigfile_disable(args.buf) end
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = bigfile_group,
  desc = 'Disable heavy features for files with very long lines',
  callback = function(args)
    if vim.b[args.buf].bigfile then return end
    for _, line in ipairs(vim.api.nvim_buf_get_lines(args.buf, 0, 50, false)) do
      if #line > bigfile_line_len then
        bigfile_disable(args.buf)
        bigfile_disable_highlight(args.buf)
        return
      end
    end
  end,
})

-- treesitter and syntax start on FileType, after BufReadPre, so stop them once they have started
vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter' }, {
  group = bigfile_group,
  callback = function(args)
    if vim.b[args.buf].bigfile then vim.schedule(function() bigfile_disable_highlight(args.buf) end) end
  end,
})

return {
  -- 'tpope/vim-unimpaired',
  { 'folke/zen-mode.nvim', cmd = 'ZenMode' },
  'junegunn/vim-easy-align',
  { 'szw/vim-maximizer', cmd = 'MaximizerToggle' },
  'tpope/vim-dispatch',
  'tpope/vim-repeat', -- better repeat
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
    cmd = 'UndotreeToggle',
    keys = { { '<leader>u', ':UndotreeToggle<CR>', noremap = true, desc = 'Open/close UndoTree' } },
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
    -- A task runner and job management plugin for Neovim
    -- https://github.com/stevearc/overseer.nvim
    'stevearc/overseer.nvim',
    opts = {},
    event = 'VeryLazy',
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

  {
    'ThePrimeagen/harpoon',
    keys = {
      { '<C-s><C-h>', ':lua SendToHarpoon(1, 0)<CR>', noremap = true, desc = 'Send to Harpoon (normal mode)' },
      { mode = 'v', '<C-s><C-h>', ':lua SendToHarpoon(1, 1)<CR>', noremap = true, desc = 'Send to Harpoon (visual mode)' },
      { '<C-h>', ':lua require("harpoon.ui").nav_file(1)<cr>', noremap = true, desc = 'Harpoon file 1' },
      { '<C-j>', ':lua require("harpoon.ui").nav_file(2)<cr>', noremap = true, desc = 'Harpoon file 2' },
      { '<C-k>', ':lua require("harpoon.ui").nav_file(3)<cr>', noremap = true, desc = 'Harpoon file 3' },
      { '<C-l>', ':lua require("harpoon.ui").nav_file(4)<cr>', noremap = true, desc = 'Harpoon file 4' },
      { '<C-h><C-h>', ':lua require("harpoon.term").gotoTerminal(1)<cr>i', noremap = true, desc = 'Harpoon Terminal 1' },
      { '<C-j><C-j>', ':lua require("harpoon.term").gotoTerminal(2)<cr>i', noremap = true, desc = 'Harpoon Terminal 2' },
      { '<C-k><C-k>', ':lua require("harpoon.term").gotoTerminal(3)<cr>i', noremap = true, desc = 'Harpoon Terminal 3' },
      { '<C-l><C-l>', ':lua require("harpoon.term").gotoTerminal(4)<cr>i', noremap = true, desc = 'Harpoon Terminal 4' },
      { '<leader>hh', ':lua require("harpoon.mark").add_file()<CR>', noremap = true, desc = 'Add file to Harpoon marks' },
      { '<leader>hm', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', noremap = true, desc = "Harpoon's quick menu" },
    },
  },

  -- {
  --   'Bekaboo/dropbar.nvim',
  --   -- optional, but required for fuzzy finder support
  --   dependencies = {
  --     'nvim-telescope/telescope-fzf-native.nvim',
  --     build = 'make',
  --   },
  -- },
}
