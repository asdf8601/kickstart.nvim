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
  { 'mbbill/undotree', },
  {
    'jpalardy/vim-slime',
  },
  { 'ThePrimeagen/harpoon', },

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
  {
    'folke/which-key.nvim',
    opts = {},
    init = function()
      vim.o.timeout = true
      require("which-key").setup({
        icons = {
          breadcrumb = ">>",
          separator = ">",
          group = "+",
        },
      })
    end,
  },
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
    'folke/tokyonight.nvim',
    priority = 1000, -- make sure to load this before all the other start plugins
    init = function()
			require("tokyonight").setup({
				style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
				light_style = "day", -- The theme is used when the background is set to light
				transparent = true, -- Enable this to disable setting the background color
				terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
				styles = {
					-- Style to be applied to different syntax groups
					-- Value is any valid attr-list value for `:help nvim_set_hl`
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
					-- Background styles. Can be "dark", "transparent" or "normal"
					sidebars = "dark", -- style for sidebars, see below
					floats = "dark", -- style for floating windows
				},
				sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
				day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
				hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
				dim_inactive = false, -- dims inactive windows
				lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

				--- You can override specific color groups to use other groups or a hex color
				--- function will be called with a ColorScheme table
				---@param colors ColorScheme
				on_colors = function(colors) end,

				--- You can override specific highlights to use other groups or a hex color
				--- function will be called with a Highlights and ColorScheme table
				---@param highlights Highlights
				---@param colors ColorScheme
				on_highlights = function(highlights, colors) end,
			})
      vim.cmd.colorscheme 'tokyonight-night'
      -- vim.cmd.hi 'Comment gui=none'
    end,
  },
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    enabled = false,
    priority = 1000,
    init = function()
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

      pcall(require('telescope').load_extension, 'fzf')
      vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<C-p>', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
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
        'c',
        'cpp',
        'go',
        'python',
        'lua',
        'rust',
        'tsx',
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

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

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
  -- ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
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
  astro = {},
  ruff_lsp = {},
  pyright = {},
  bashls = {},
  dockerls = {},
  efm = {},
  gopls = {},
  clangd = {},
  rust_analyzer = {},
  tsserver = {},
  terraformls = {},
  tflint = {},
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
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
local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup({})

cmp.setup({
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
    -- ['<tab>'] = cmp.mapping.complete(),
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
    -- { name = 'nvim_lsp_signature_help' },
    -- { name = 'neorg' },
    -- { name = 'orgmode' },
  },
})










-- [settings] {{
function UseZsh()
  local handle = io.popen("which zsh")
  if handle == nil then
    return
  end
  local result = handle:read("*a")
  handle:close()

  if result ~= '' then
    -- Esto elimina los espacios en blanco
    vim.o.shell = result:match("^%s*(.-)%s*$")
  end
end

UseZsh()

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
vim.o.updatetime = 50
-- vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.textwidth = 79
vim.o.cursorline = true
vim.o.colorcolumn = "80" -- works! (using integer will fail)
vim.o.completeopt = 'menuone,noselect'
vim.g.netrw_hide = 0
vim.g.netrw_nogx = 1
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20
vim.o.laststatus = 2
-- }}

-- [[ fugitive ]] {{
vim.keymap.set("n", "<leader>w", ":Git<cr>", { noremap = true, desc = "Open Git status" })
vim.keymap.set("n", "<leader>W", ":tab Git<cr>", { noremap = true, desc = "Open Git status in a new tab" })
vim.keymap.set('n', '<C-g>', ':GBrowse<cr>', { noremap = true, desc = 'browse current file on github' })
vim.keymap.set('v', '<C-g>', ':GBrowse<cr>', { noremap = true, desc = 'browse current file and line on github' })
vim.keymap.set('n', '<C-G>', ':GBrowse!<cr>', { noremap = true, desc = 'yank github url of the current file' })
vim.keymap.set('v', '<C-G>', ':GBrowse!<cr>', { noremap = true, desc = 'yank github url of the current line' })
-- }}

-- terminal settings {{
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true, desc = "Switch to normal mode" })
vim.keymap.set('t', '<C-w>h', '<C-\\><C-n><C-w>h', { noremap = true, desc = "Move cursor to the left window" })
vim.keymap.set('t', '<C-w>j', '<C-\\><C-n><C-w>j', { noremap = true, desc = "Move cursor to the below window" })
vim.keymap.set('t', '<C-w>k', '<C-\\><C-n><C-w>k', { noremap = true, desc = "Move cursor to the above window" })
vim.keymap.set('t', '<C-w>l', '<C-\\><C-n><C-w>l', { noremap = true, desc = "Move cursor to the right window" })
vim.keymap.set('t', '<C-w>w', '<C-\\><C-n><C-w>w', { noremap = true, desc = "Switch to the next window" })
-- vim.keymap.set('t', '<C-P>', '<C-\\><C-n>pi<cr>', { noremap = true })
-- vim.keymap.set('n', '<C-l>', 'i<C-l>', {noremap = true})
-- }}


-- [[ luasnip:snippets ]] {{
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


-- }}


-- {{ slime
vim.g.slime_last_channel = { nil }
vim.g.slime_cell_delimiter = '\\s*#\\s*%%'
vim.g.slime_paste_file = os.getenv("HOME") .. "/.slime_paste"

local function next_cell()
  vim.fn.search(vim.g.slime_cell_delimiter)
end

local function prev_cell()
  vim.fn.search(vim.g.slime_cell_delimiter, "b")
end

vim.keymap.set('n', '<leader>e', vim.cmd.SlimeSend, { noremap = true, desc = 'send line to term' })
vim.keymap.set('n', '<leader>cv', vim.cmd.SlimeConfig, { noremap = true, desc = "Open slime configuration" })
vim.keymap.set('x', '<leader>e', '<Plug>SlimeRegionSend', { noremap = true, desc = 'send line to tmux' })
vim.keymap.set('n', '<leader>ep', '<Plug>SlimeParagraphSend', { noremap = true, desc = "Send Paragraph with Slime" })
vim.keymap.set('n', '<leader>ck', prev_cell, { noremap = true, desc = "Search backward for slime cell delimiter" })
vim.keymap.set('n', '<leader>cj', next_cell, { noremap = true, desc = "Search forward for slime cell delimiter" })
vim.keymap.set('n', '<leader>cc', '<Plug>SlimeSendCell', { noremap = true, desc = "Send cell to slime" })


vim.g.slime_get_jobid = function()
  local buffers = vim.api.nvim_list_bufs()
  -- local terminal_buffers = {}
  local terminal_buffers = { "Select terminal:\nbuffer\tjobid\tname", }
  local name = ""
  local jid = 1

  for _, buf in ipairs(buffers) do
    if vim.bo[buf].buftype == 'terminal' then
      -- table.insert(terminal_buffers, buf)
      jid = vim.api.nvim_buf_get_var(buf, 'terminal_job_id')
      name = vim.api.nvim_buf_get_name(buf)
      table.insert(terminal_buffers, buf .. "\t" .. jid .. "\t" .. name)
    end
  end

  -- Assuming you have a way to choose from terminal_buffers
  -- For simplicity, let's say the user chooses the first terminal
  -- local chosen_terminal = terminal_buffers[1]
  local chosen_terminal = vim.fn.inputlist(terminal_buffers)

  if chosen_terminal then
    local jobid = vim.api.nvim_buf_get_var(chosen_terminal, 'terminal_job_id')
    print("\n[slime] jobid chosen: ", jobid)
    return jobid
  else
    print("No terminal found")
  end
end


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
  vim.g.slime_bracketed_paste = 1
  vim.g.slime_python_ipython = 1
  vim.g.slime_no_mappings = 1
  -- vim.g.slime_default_config = nil
  -- vim.g.slime_dont_ask_default = 0
end

slime_use_neovim()
-- slime_use_tmux()
-- }}

-- {{
-- [[ pdbrc ]] {{
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

-- keymaps
vim.keymap.set('n', 'bp', AddPdbrc, { noremap = true, silent = true, desc = 'Add pdbrc' })

vim.keymap.set('i', 'kj', '<esc>', { noremap = true, silent = true })
vim.keymap.set('i', 'jk', '<esc>', { noremap = true, silent = true })

-- shebang
vim.keymap.set('n', '<leader>sh', ":0<cr>O#!/usr/bin/env bash<esc><C-o>", { desc = 'Add shebang' })

-- commands
vim.keymap.set('n', 'sh', ':.!sh ', { noremap = true, desc = 'Fill command to execute sh using current line' })
vim.keymap.set('n', '<c-s><c-l>', ':!<C-R><C-L>',
  { noremap = true, desc = 'Fill command to execute sh using current line' })
vim.keymap.set('n', '<c-s><c-s>', ':.!sh<cr>', { noremap = true, desc = 'Execute sh current line' })

-- Explore
-- vim.keymap.set('n', '-', ':Ex<cr>', { desc = "Open the current file's directory in the file explorer", silent = false })
vim.keymap.set('n', '<leader>-', ':Ex %:h<cr>',
  { desc = "Open the current file's directory in the file explorer", silent = false })

-- paste / yank / copy
vim.keymap.set('n', '<leader>0', '"0p', { desc = "Paste from register 0", silent = false })
vim.keymap.set('n', '<leader>1', '"1p', { desc = "Paste from register 1", silent = false })
vim.keymap.set("v", "<C-c>", "\"0y", { noremap = true, desc = 'yank to clipboard' })
vim.keymap.set("n", "<C-c>", "\"0yy", { noremap = true, desc = 'yank to clipboard' })
vim.keymap.set('n', '<C-v><C-v>', '"0p', { desc = 'Paste 0 register' })
vim.keymap.set('i', '<C-v>', '<C-r>0', { desc = 'Paste 0 register' })
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste clipboard register' })
vim.keymap.set('v', '<leader>p', '"+p', { desc = 'Paste clipboard register' })
vim.keymap.set('n', '<leader>y', '"+yy', { noremap = true, desc = 'copy to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, desc = 'copy to system clipboard' })
vim.keymap.set('n', '<leader>yf', ':let @+ = expand("%:p")<cr>', { noremap = true, desc = 'yank filename/buffer path' })

-- reload
vim.keymap.set('n', '<leader><cr>', ':source ~/.config/nvim/init.lua<cr>', { noremap = true })
vim.keymap.set('n', '<leader>rc', ':vnew ~/.config/nvim/init.lua<cr>', { noremap = true })


-- replace in all file
vim.keymap.set('n', '<leader>s', ':%s/<C-r><C-w>/<C-r><C-w>/gI<left><left><left>', { noremap = true, desc = 'search and replace word under cursor' })
-- vim.keymap.set('n', 'gs', ':%s//g<left><left>', {noremap = true, desc = 'search and replace' })
vim.keymap.set("n", "<leader>gw", ":grep '<C-R><C-W>'", { desc = "Find word using grep command" })
--
vim.keymap.set('i', '<C-J>', '<esc>:.m+1 | startinsert<cr>', { noremap = true, desc = 'move line down' })
vim.keymap.set('i', '<C-K>', '<esc>:.m-2 | startinsert<cr>', { noremap = true, desc = 'move line up' })

vim.keymap.set('n', '<leader>k', ':m .-2<cr>==', { noremap = true, desc = 'move line up' })
vim.keymap.set('n', '<leader>j', ':m .+1<cr>==', { noremap = true, desc = 'move line down' })

vim.keymap.set('n', '<leader>cn', ':cnext<cr>', { noremap = true, desc = 'next error' })
vim.keymap.set('n', '<leader>cp', ':cprev<cr>', { noremap = true, desc = 'previous error' })
-- }}
--

vim.cmd [[
augroup Latex
  au!
  au BufWritePost *.tex silent !dex pdflatex % && firefox %:t:r.pdf
augroup end
]]

-- terraform {{
-- https://www.mukeshsharma.dev/2022/02/08/neovim-workflow-for-terraform.html
vim.cmd([[
augroup terraform
  autocmd!
	autocmd filetypedetect BufRead,BufNewFile *.tf
	autocmd BufRead,BufNewFile *.hcl set filetype=hcl
	autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl
	autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform
	autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json
augroup end
]])
vim.keymap.set("n", "<leader>ti", ":!terraform init<CR>", { noremap = true, desc = "Terraform init" })
vim.keymap.set("n", "<leader>tv", ":!terraform validate<CR>", { noremap = true, desc = "Terraform validate" })
vim.keymap.set("n", "<leader>tp", ":!terraform plan<CR>", { noremap = true, desc = "Terraform plan" })
vim.keymap.set("n", "<leader>taa", ":!terraform apply -auto-approve<CR>", { noremap = true, desc = "Terraform apply auto approve" })
require('lspconfig').terraformls.setup {}
require('lspconfig').tflint.setup {}
-- }}


-- GOLANG {{
-- wrap go command into a Go neovim command so I can call it from lua.
-- local function gofix()
--     -- fix inplace
--     vim.api.nvim_command('silent !gofmt -w %')
--     vim.api.nvim_command('silent !goimports -w %')
--     vim.api.nvim_command('silent !golines -w %')
-- end
-- local golang = vim.api.nvim_create_augroup('GoLang', { clear = true })
-- vim.api.nvim_create_autocmd('BufWritePost', {
--   group = golang,
--   pattern = 'go.mod',
--   callback = function()
--     vim.api.nvim_command('!go mod tidy')
--   end
-- })
-- vim.api.nvim_create_autocmd('BufWritePost', {
--   callback = gofix,
--   group = golang,
--   pattern = '*.go',
-- })
-- vim.api.nvim_create_user_command('Gofix', gofix, {})
-- vim.api.nvim_create_user_command('Gorun', '!go run %', {})
-- vim.api.nvim_create_user_command('Gotest', '!go test %', {})
-- vim.api.nvim_create_user_command('Gobuild', '!go build %', {})
-- vim.api.nvim_create_user_command('Govet', '!go vet %', {})

-- local golangcmd = function ()
--   -- find .git directory
--   local cwd = vim.fn.getcwd()
--   local parent = ""
--   -- build cmd
--   cmd = "golangci-lint run -c " .. cwd .. "/.golangci.yml go/..."
--   -- execute cmd
--   vim.cmd(cmd)
--   -- autocmd BufWritePost *.go execute "!golang cilint -c ""> /tmp/quickfix" | execute "e /tmp/quickfix"
-- end

vim.cmd([[
  " GoLang
  augroup golang
    autocmd!
    autocmd BufRead go.mod setlocal filetype=go
    autocmd BufWritePost go.mod silent !go mod tidy
    autocmd BufWritePost *.go execute "silent !gofmt -w %" | execute "silent !goimports -w %" | execute "silent !golines -w %"
  augroup END
]])


-- if macos then
if vim.fn.has('mac') == 1 then
  vim.cmd([[
    augroup macos
      autocmd!
      autocmd BufWritePost yabairc silent !yabai --restart-service
      autocmd BufWritePost skhdrc silent !skhd --restart-service
    augroup END
  ]])
end

-- }}

vim.api.nvim_create_user_command('PushAirflow', '!gsutil cp -r % gs://europe-west1-data-cloud-com-831c7a66-bucket/%', {})

-- vim.cmd.colorscheme 'modus_vivendi'
-- vim.cmd.colorscheme 'modus-vivendi'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et tw=0
