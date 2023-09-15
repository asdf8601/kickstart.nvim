--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
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

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      require('onedark').setup({
        term_colors = true,
        style = 'darker',
        toggle_style_key = ',ts', -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
        transparent = true,       -- Show/hide background
        diagnostics = {
          darker = true,          -- darker colors for diagnostic
          undercurl = true,       -- use undercurl instead of underline for diagnostics
          background = false,     -- use background color for virtual text
        },
      })
      vim.cmd.colorscheme 'onedark'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
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
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep({
      search_dirs = {git_root},
    })
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
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

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  ruff_lsp = {},
  pyright = {},
  bashls = {},
  dockerls = {},
  efm = {},
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
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

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    -- ['<C-l>'] = cmp.mapping.complete(),
    ['<C-l>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'copilot' },
    { name = 'path' },
    -- { name = 'buffer' },
    -- { name = 'neorg' },
    -- { name = 'nvim_lsp_signature_help' },
    -- { name = 'orgmode' },
  },
}



-- Custom setup {{
-- [[ Setting options ]]
vim.o.t_Co = 256
vim.o.scrollback = 20000
-- vim.o.guicursor=""
-- vim.o.nohlsearch = true
-- vim.o.hidden = true
-- vim.o.noerrorbells = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
-- vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
-- vim.o.noswapfile = true
-- vim.o.nobackup = true
vim.o.undodir = os.getenv("HOME") .. '/.vim/undodir'
vim.o.undofile = true
vim.o.incsearch = true
vim.o.scrolloff = 8
-- vim.o.signcolumn='no'
vim.o.cmdheight = 1
vim.o.timeoutlen = 200
vim.o.updatetime = 50
-- vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.textwidth = 79
vim.o.cursorline = true
vim.o.colorcolumn = "80" -- works! (using integer will fail)
vim.o.completeopt = 'menuone,noselect'
vim.g.netrw_hide = 0
vim.o.laststatus = 3

-- bang chatgpt command
vim.api.nvim_set_keymap('n', '<C-c>%', ':%!chatgpt -p "Avoid comments and explanaitions unless I ask for it. "<left>', { noremap = true, desc = '%!chatgpt' })
vim.api.nvim_set_keymap('n', '<C-c>.', ':.!chatgpt -p "Avoid comments and explanaitions unless I ask for it. "<left>', { noremap = true, desc = '.!chatgpt' })
vim.api.nvim_set_keymap('v', '<C-c>.', ':!chatgpt -p "Avoid comments and explanaitions unless I ask for it. "<left>', { noremap = true, desc = '!chatgpt' })

-- Explore
vim.keymap.set('n', '<leader>-', ':Ex %:h<cr>', { desc = "Open the current file's directory in the file explorer", silent = false })
vim.o.completeopt = 'menuone,noselect'

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.git_files, { noremap = true, desc = 'Find files in git repo' })
vim.keymap.set('n', '<leader>gs', builtin.git_stash, { noremap = true, desc = 'Git stash' })
local ignore_patterns = { "venv/", ".venv/", ".git/", "node_modules/", "*.pyc", "__.*cache.*/", "*.pkl", "*.pickle", "*.mat" }
local actions = require('telescope.actions')

local function search_scio()
  -- function to edit a file
  local vim_edit_prompt = function(prompt_bufnr)
    local current_picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
    local prompt = current_picker:_get_prompt()
    local cwd = current_picker.cwd
    actions.close(prompt_bufnr)
    vim.api.nvim_exec(':edit ' .. cwd .. '/' .. prompt, false)
    return true
  end
  require("telescope.builtin").find_files({
    prompt_title = "< scio >",
    cwd = "~/github/mmngreco/scio",
    hidden = true,
    no_ignore = true,
    attach_mappings = function(_, map)
      map('i', '<c-n>', vim_edit_prompt)
      return true
    end
  })
end

local function search_dotfiles()
  require("telescope.builtin").find_files({
    prompt_title = "< dotfiles >",
    cwd = "$DOTFILES_HOME",
    hidden = true,
    no_ignore = true,
  })
end

local function find_files()
  require("telescope.builtin").find_files({
    file_ignore_patterns = ignore_patterns,
    hidden = true,
    no_ignore = true,
    follow = true,
  })
end

local function git_branches()
  require("telescope.builtin").git_branches({
    attach_mappings = function(_, map)
      map('i', '<c-d>', actions.git_delete_branch)
      map('n', '<c-d>', actions.git_delete_branch)
      map('i', '<c-b>', actions.git_create_branch)
      return true
    end
  })
end

vim.keymap.set('n', '<leader>dot', search_dotfiles, { desc = "Search dotfiles", noremap = true })
vim.keymap.set('n', '<Leader>ff', find_files, { desc = "Find files", noremap = true })
vim.keymap.set('n', '<leader>gc', git_branches, { desc = "Git branches", noremap = true })
vim.keymap.set('n', '<leader>sc', search_scio, { desc = "Search scio", noremap = true })

-- augroups


vim.keymap.set('n', '<leader><cr>', ':source ~/.config/nvim/init.lua<cr>', { noremap = true })
vim.keymap.set('n', '<leader>rc', ':new ~/.config/nvim/init.lua<cr>', { noremap = true })

local mmngreco = vim.api.nvim_create_augroup('mmngreco', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', { group = mmngreco, pattern = '*', command = '%s/\\s\\+$//e' })
vim.api.nvim_create_autocmd('BufWritePre', { group = mmngreco, pattern = '*.go', command = 'GoFmt' })
vim.api.nvim_create_autocmd('BufEnter', { group = mmngreco, pattern = '*.dbout', command = 'norm zR' })
vim.api.nvim_create_autocmd('FileType', { group = mmngreco, pattern = 'markdown', command = 'setl conceallevel=2 spl=en,es' })
vim.api.nvim_create_autocmd('FileType', { group = mmngreco, pattern = 'make', command = 'setl noexpandtab shiftwidth=4 softtabstop=0' })
vim.api.nvim_create_autocmd('TermOpen', { group = mmngreco, pattern = '*', command = 'setl nonumber norelativenumber' })
vim.api.nvim_create_autocmd('FileType', { group = mmngreco, pattern = 'fugitive', command = 'setl nonumber norelativenumber' })
vim.api.nvim_create_autocmd('FileType', { group = mmngreco, pattern = 'python', command = 'nnoremap <buffer> <F8> :silent !black -l79 -S %<CR><CR>' })
vim.api.nvim_create_autocmd('FileType', { group = mmngreco, pattern = 'python', command = 'nnoremap <buffer> <F7> :silent !ruff -l79 %<CR><CR>' })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, { pattern = 'Jenkinsfile', group = mmngreco, command = 'setl ft=groovy' })

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- local yank_group = augroup('HighlightYank', {})
Mgreco = augroup('mgreco', {})
autocmd({ "BufWritePre" }, {
  group = Mgreco,
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

autocmd({ 'FileType' }, {
  group = Mgreco,
  pattern = "dbui",
  command = "nmap <buffer> <leader>w <Plug>(DBUI_SaveQuery)",
})

autocmd({ 'FileType' }, {
  group = Mgreco,
  pattern = "markdown",
  command = "normal zR",
})

vim.keymap.set('n', '<leader>sq', '<Plug>(DBUI_SaveQuery)', { noremap = true })

autocmd({ 'FileType' }, {
  group = Mgreco,
  pattern = "dbui",
  command = "setl nonumber norelativenumber",
})

autocmd({ 'BufWritePost' }, {
  group = Mgreco,
  pattern = "~/.Xresources",
  command = "silent !xrdb <afile> > /dev/null",
})


if vim.fn.has('mac') == 1 then
  vim.g.netrw_browsex_viewer = 'open'
else
  -- Set the default viewer for other operating systems
  vim.g.netrw_browsex_viewer = 'xdg-open'
end

-- terminal settings
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true, desc = "Switch to normal mode" })
vim.keymap.set('t', '<C-w>h', '<C-\\><C-n><C-w>h', { noremap = true, desc = "Move cursor to the left window" })
vim.keymap.set('t', '<C-w>j', '<C-\\><C-n><C-w>j', { noremap = true, desc = "Move cursor to the below window" })
vim.keymap.set('t', '<C-w>k', '<C-\\><C-n><C-w>k', { noremap = true, desc = "Move cursor to the above window" })
vim.keymap.set('t', '<C-w>l', '<C-\\><C-n><C-w>l', { noremap = true, desc = "Move cursor to the right window" })
vim.keymap.set('t', '<C-w>w', '<C-\\><C-n><C-w>w', { noremap = true, desc = "Switch to the next window" })
-- vim.keymap.set('t', '<C-P>', '<C-\\><C-n>pi<cr>', { noremap = true })
-- vim.keymap.set('n', '<C-l>', 'i<C-l>', {noremap = true})

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

-- [[ jupytext ]]
vim.g.jupytext_filetype_map = { py = 'python' }
vim.g.jupytext_fmt = 'py:percent'


-- slow_cmd_time

vim.g.slime_cell_delimiter = [[\s*#\s*%%]]
vim.g.slime_paste_file = os.getenv("HOME") .. "/.slime_paste"
vim.keymap.set('n', '<leader>e', ':SlimeSend<cr>', { noremap = true, desc = 'send line to term' })
vim.keymap.set('x', '<leader>e', '<Plug>SlimeRegionSend', { noremap = true, desc = 'send line to tmux' })
vim.keymap.set('n', '<leader>cv', ':SlimeConfig<cr>', { noremap = true, desc = "Open SlimeConfig" })
vim.keymap.set('n', '<leader>ep', '<Plug>SlimeParagraphSend', { noremap = true, desc = "Send Paragraph with Slime" })
-- vim.keymap.set('n', '<leader>cc', '<Plug>SlimeSendCell', {noremap = true})
vim.keymap.set('n', '<leader>ck', '<cmd>call search(g:slime_cell_delimiter, "b")<cr>', { noremap = true, desc = "Search backward for slime cell delimiter" })
vim.keymap.set('n', '<leader>cj', '<cmd>call search(g:slime_cell_delimiter)<cr>', { noremap = true, desc = "Search forward for slime cell delimiter" })
vim.keymap.set('n', '<leader>cv', ':SlimeConfig<cr>', { noremap = true, desc = "Open slime configuration" })
vim.keymap.set('n', '<leader>ep', '<Plug>SlimeParagraphSend', { noremap = true, desc = "Send paragraph to slime" })
vim.keymap.set('n', '<leader>cc', '<Plug>SlimeSendCell', { noremap = true, desc = "Send cell to slime" })

local function slime_use_tmux()
  vim.g.slime_target = "tmux"
  vim.g.slime_bracketed_paste = 1
  vim.g.slime_python_ipython = 0
  vim.g.slime_no_mappings = 1
  vim.g.slime_default_config = { socket_name = "default", target_pane = ":.2" }
  vim.g.slime_dont_ask_default = 1
end

local function slime_use_neovim()
  vim.g.slime_target = "neovim"
  vim.g.slime_bracketed_paste = 0
  vim.g.slime_python_ipython = 1
  -- vim.g.slime_default_config = {}
  vim.g.slime_no_mappings = 1
  vim.g.slime_dont_ask_default = 0
end

slime_use_neovim()
-- slime_use_tmux()
local function toggle_slime_target()
  if vim.g.slime_target == "neovim" then
    slime_use_tmux()
  else
    slime_use_neovim()
  end
end
vim.api.nvim_create_user_command('SlimeToggleTarget', toggle_slime_target, { nargs = 0 })

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

vim.keymap.set('n', '<leader>s', ':%s/<C-r><C-w>/<C-r><C-w>/gI<left><left><left>', { noremap = true, desc = 'search and replace word under cursor' })
-- vim.keymap.set('n', 'gs', ':%s//g<left><left>', {noremap = true, desc = 'search and replace' })

vim.keymap.set('i', '<C-J>', '<esc>:.m+1 | startinsert<cr>', { noremap = true, desc = 'move line down' })
vim.keymap.set('i', '<C-K>', '<esc>:.m-2 | startinsert<cr>', { noremap = true, desc = 'move line up' })

vim.keymap.set('n', '<leader>k', ':m .-2<cr>==', { noremap = true, desc = 'move line up' })
vim.keymap.set('n', '<leader>j', ':m .+1<cr>==', { noremap = true, desc = 'move line down' })

vim.keymap.set('n', '<leader>cn', ':cnext<cr>', { noremap = true, desc = 'next error' })
vim.keymap.set('n', '<leader>cp', ':cprev<cr>', { noremap = true, desc = 'previous error' })


-- vim.keymap.set('n', '<leader>sn', ':\'<,\'>!sort -n -k 2', { noremap = true, desc = 'sort lines numerically' })
-- vim.keymap.set('v', '<leader>s', ':\'<,\'>!sort -f<cr>', { noremap = true, desc = 'sort lines' })
vim.keymap.set('v', '<leader>sf', ':!sqlformat  -k upper -r --indent_after_first --indent_columns -<cr>', { noremap = true })

vim.keymap.set('n', '<leader>tu', 'yypvawr-', { noremap = true, desc = 'underline word under cursor' })
vim.keymap.set('n', '<leader>tx', ':s/\\[\\s\\?\\]/[x]/<cr>', { noremap = true, desc = 'check a box in markdown' })
vim.keymap.set('n', '<leader>t<space>', ':s/\\[x\\]/[ ]/<cr>', { noremap = true, desc = 'uncheck a box in markdown' })
vim.keymap.set('n', '<leader>ta', 'I- [ ] <esc>', { noremap = true, desc = 'append empty checkbox in markdown' })
vim.keymap.set('n', '<leader>m', ':MaximizerToggle<cr>', { noremap = true, desc = 'Maximize current window' })

-- [[ checkbox ]]
function SummaryCheckboxes()
  local line = vim.fn.line('.')
  -- local line_orig = vim.fn.getline('.')
  local checked = 0
  local total = 0

  -- find the first line of the paragraph
  while line > 1 and vim.fn.getline(line - 1) ~= '' do
    line = line - 1
  end

  while true do
    local line_text = vim.fn.getline(line)
    if line_text:match('^%s*%-%s%[[xX]%]') then
      checked = checked + 1
      total = total + 1
    elseif line_text:match('^%s*%-%s%[.%]') then
      total = total + 1
    else
      break
    end
    line = line + 1
  end

  vim.api.nvim_input("vipo<esc>A (" .. checked .. "/" .. total .. ")<esc>")
  return { checked, total }
end

-- [[ fugitive ]] {{
vim.keymap.set("n", "<leader>w", ":Git|10wincmd_<cr>", { noremap = true, desc = "Open Git status" })
vim.keymap.set('n', '<C-g>', ':GBrowse<cr>', { noremap = true, desc = 'browse current file on github' })
vim.keymap.set('v', '<C-g>', ':GBrowse<cr>', { noremap = true, desc = 'browse current file and line on github' })
vim.keymap.set('n', '<C-G>', ':GBrowse!<cr>', { noremap = true, desc = 'yank github url of the current file' })
vim.keymap.set('v', '<C-G>', ':GBrowse!<cr>', { noremap = true, desc = 'yank github url of the current line' })
-- }}


vim.cmd[[
  let g:gist_clip_command = 'xclip -selection clipboard'
  let g:gist_detect_filetype = 1
  let g:gist_open_browser_after_post = 1
  let g:gist_show_privates = 1
  let g:gist_user = "mmngreco"
  let g:gist_token = $GH_GIST_TOKEN
]]


-- [[ dap
require("dapui").setup()
require("nvim-dap-virtual-text").setup({})
require("dap-python").setup(os.getenv('HOME') .. '/.venv-nvim/bin/python')

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

-- [[ dap:ui ]]
local dapui = require('dapui')
vim.keymap.set('n', '<leader>du', dapui.toggle, { noremap = true, desc = 'toggle dap ui' })
vim.keymap.set('n', '<leader>do', dapui.open, { noremap = true, desc = 'toggle dap ui' })
vim.keymap.set('n', '<leader>dx', dapui.close, { noremap = true, desc = 'toggle dap ui' })
-- ]]

-- [[ luasnip:snippets ]]
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
ls.add_snippets('all', {
  s('hola', t 'hola mundo!')
})

ls.add_snippets('python', {
  s('pdb', t '__import__("pdb").set_trace()')
})

ls.add_snippets('python', {
  s('pm', t '__import__("pdb").pm()')
})

-- date
ls.add_snippets('all', {
  s('date', t(os.date('%Y-%m-%d')))
})

vim.keymap.set('n', '<leader>zz', '<cmd>ZenMode<cr>', { noremap = true, desc = 'ZenMode toggle' })

-- scratch
function CreateScratch()
  local parent = './scratch'
  if vim.fn.isdirectory(parent) == 0 then
    parent = '.'
  end
  local num = 0
  local ext = vim.fn.input('Enter extension (.py)', '.py')
  local file = function(n) return vim.fn.expand(parent .. '/' .. n .. ext) end

  while (vim.fn.filereadable(file(num)) == 0) and (num <= 1000) do
    num = num + 1
  end
  vim.cmd('10new ' .. file(num))

  -- vim.bo.buftype = '__scratch__'
  -- vim.bo.filetype = 'markdown'
  -- vim.bo.bufhidden = 'wipe'
  -- vim.bo.swapfile = false
  vim.bo.modifiable = true
  vim.bo.textwidth = 0
end
vim.keymap.set('n', '<leader>ss', ':lua CreateScratch()<cr>', { noremap = true, desc = 'create scratch buffer' })

vim.keymap.set("v", "<leader>h", ":<c-u>HSHighlight 2<cr>", { noremap = true, desc = 'high-str' })
-- vim.keymap.set("n", "<leader>h", ":<c-u>HSHighlight 2<cr>", {noremap = true, desc = 'high-str'})

vim.keymap.set("v", "<C-c>", "\"0y", { noremap = true, desc = 'yank to clipboard' })
vim.keymap.set("n", "<C-c>", "\"0yy", { noremap = true, desc = 'yank to clipboard' })

vim.keymap.set('n', '<C-v><C-v>', '"0p', { desc = 'Paste 0 register' })
vim.keymap.set('i', '<C-v>', '<C-r>0', { desc = 'Paste 0 register' })

vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste clipboard register' })
vim.keymap.set('v', '<leader>p', '"+p', { desc = 'Paste clipboard register' })
vim.keymap.set('n', '<leader>y', '"+yy', { noremap = true, desc = 'copy to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, desc = 'copy to system clipboard' })
vim.keymap.set('n', '<leader>yf', ':let @+ = expand("%:p")<cr>', { noremap = true, desc = 'yank filename/buffer path' })

-- [[ pdbrc ]] {{
local pdbrc_win
local current_win

function AddPdbrc()
  local file = vim.fn.expand('%:p')
  local line = vim.fn.line('.')
  local cmd = "b " .. file .. ":" .. line

  local full_cmd = [[!echo ']] .. cmd .. [[' >> .pdbrc]]
  vim.cmd(full_cmd)

  -- Guardar la ventana actual
  current_win = vim.api.nvim_get_current_win()

  -- Comprobar si .pdbrc ya está abierto
  if not pdbrc_win or not vim.api.nvim_win_is_valid(pdbrc_win) then
    -- Abrir .pdbrc en un buffer superior con 5 líneas de alto si no está abierto
    vim.cmd('5split .pdbrc')
    pdbrc_win = vim.api.nvim_get_current_win()
  else
    -- Activar la ventana donde se abrió .pdbrc
    vim.api.nvim_set_current_win(pdbrc_win)
  end
  vim.cmd('norm G')

  vim.api.nvim_set_current_win(current_win)
end

vim.api.nvim_set_keymap('n', '<C-b><C-b>', ':lua AddPdbrc()<CR><CR>', { noremap = true, silent = true, desc = 'Add pdbrc' })
-- }}


-- send to harpoon terminal {{
vim.keymap.set('n', '<C-s><C-h>', ':lua SendToHarpoon(1, 0)<CR>', { noremap = true, desc = "Send to Harpoon (normal mode)" })
vim.keymap.set('v', '<C-s><C-h>', ':lua SendToHarpoon(1, 1)<CR>', { noremap = true, desc = "Send to Harpoon (visual mode)" })
-- open harpoon menu
vim.keymap.set('n', '<leader>ha', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', { noremap = true, desc = "Harpoon's quick menu" })

vim.keymap.set('n', '<C-h>', ':lua require("harpoon.ui").nav_file(1)<cr>', { noremap = true, desc = 'Harpoon file 1' })
vim.keymap.set('n', '<C-j>', ':lua require("harpoon.ui").nav_file(2)<cr>', { noremap = true, desc = 'Harpoon file 2' })
vim.keymap.set('n', '<C-k>', ':lua require("harpoon.ui").nav_file(3)<cr>', { noremap = true, desc = 'Harpoon file 3' })
vim.keymap.set('n', '<C-l>', ':lua require("harpoon.ui").nav_file(4)<cr>', { noremap = true, desc = 'Harpoon file 4' })

vim.keymap.set('n', '<C-h><C-h>', ':lua require("harpoon.term").gotoTerminal(1)<cr>i', { noremap = true, desc = "Harpoon Terminal 1" })
vim.keymap.set('n', '<C-j><C-j>', ':lua require("harpoon.term").gotoTerminal(2)<cr>i', { noremap = true, desc = "Harpoon Terminal 2" })
vim.keymap.set('n', '<C-k><C-k>', ':lua require("harpoon.term").gotoTerminal(3)<cr>i', { noremap = true, desc = "Harpoon Terminal 3" })
vim.keymap.set('n', '<C-l><C-l>', ':lua require("harpoon.term").gotoTerminal(4)<cr>i', { noremap = true, desc = "Harpoon Terminal 4" })

-- add file to harpoon
vim.keymap.set('n', '<leader>hf', ':lua require("harpoon.mark").add_file()<CR>', { desc = "Add file to Harpoon marks" })
-- }}

-- add python cells
vim.keymap.set('n', '<leader>co', 'O%%<esc>:norm gcc<cr>j', { noremap = true, desc = 'Insert a cell comment above the current line' })
vim.keymap.set('n', '<leader>cO', 'o%%<esc>:norm gcc<cr>k', { noremap = true, desc = 'Insert a cell comment below the current line' })
vim.keymap.set('n', '<leader>c-', 'O<esc>77i-<esc>:norm gcc<cr>j', { noremap = true, desc = 'Insert a horizontal line of dashes above the current line' })
vim.keymap.set('n', 'vic', 'V?%%<cr>o/%%<cr>koj', { noremap = true, desc = 'Visually select a cell and insert a comment before and after it' })

-- markdown
vim.g.markdown_fenced_languages = { 'html', 'python', 'bash=sh', 'sql', 'mermaid' }
vim.g.markdown_minlines = 50

-- TODO: fill this
-- vim.g.mkdp_markdown_css = ''
vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 0
vim.g.mkdp_page_title = "${name}"
vim.g.mkdp_theme = 'light'

-- {{ Create command to call jq '.' % and replace the buffer with the output
vim.api.nvim_command('command! -buffer Jq %!jq "."')
-- }}

-- {{ grep program
vim.o.grepprg = 'rg --vimgrep'
vim.o.grepformat = '%f:%l:%c:%m'
-- }}

-- [[ formatter ]] {{
-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    lua = {
      -- "formatter.filetypes.lua" defines default configurations for the
      -- "lua" filetype
      require("formatter.filetypes.lua").stylua,

      -- You can also define your own configuration
      function()
        -- Supports conditional formatting
        if util.get_current_buffer_file_name() == "special.lua" then
          return nil
        end

        -- Full specification of configurations is down below and in Vim help
        -- files
        return {
          exe = "stylua",
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end
    },

    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
}
-- }}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et tw=0
