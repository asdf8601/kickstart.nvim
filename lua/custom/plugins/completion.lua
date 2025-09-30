return {
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',
        ['<C-z>'] = {'accept', 'fallback'}

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
  -- {
  --   -- Autocompletion
  --   'hrsh7th/nvim-cmp',
  --   dependencies = {
  --     'L3MON4D3/LuaSnip',
  --     'hrsh7th/cmp-cmdline',
  --     'hrsh7th/cmp-nvim-lsp',
  --     'hrsh7th/cmp-path',
  --     'saadparwaiz1/cmp_luasnip',
  --     {
  --       "zbirenbaum/copilot-cmp",
  --       dependencies = { {"zbirenbaum/copilot.lua", opts = {}} },
  --       opts = {},
  --     },
  --     -- 'rafamadriz/friendly-snippets',
  --   },
  --   config = function()
  --       -- https://github.com/zbirenbaum/copilot-cmp?tab=readme-ov-file#packer
  --       require("copilot").setup({
  --         suggestion = { enabled = false },
  --         panel = { enabled = false },
  --       })
  --
  --       local cmp = require('cmp')
  --
  --       local luasnip = require('luasnip')
  --       local ls = require("luasnip")
  --       local s = ls.snippet
  --       local t = ls.text_node
  --       ls.add_snippets('all', { s('hola', t 'hola mundo!') })
  --       ls.add_snippets('python', { s('pdb', t 'breakpoint()') })
  --       ls.add_snippets('python', { s('pm', t '__import__("pdb").pm()') })
  --
  --       -- date
  --       ls.add_snippets('all', { s('date', t(os.date('%Y-%m-%d'))) })
  --       ls.add_snippets('all', { s('time', t(os.date('%H:%M:%S'))) })
  --
  --       luasnip.config.setup({})
  --
  --
  --       cmp.setup({
  --         performance = {
  --           max_view_entries = 5,
  --         },
  --         snippet = {
  --           expand = function(args)
  --             luasnip.lsp_expand(args.body)
  --           end,
  --         },
  --         mapping = cmp.mapping.preset.insert {
  --           ['<C-d>'] = cmp.mapping.scroll_docs(-4),
  --           ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --           ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
  --           ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  --           -- ['<C-l>'] = cmp.mapping.complete(),
  --           ['<C-l>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true, }),
  --         },
  --         sources = {
  --           { name = 'copilot' },
  --           { name = 'luasnip' },
  --           { name = 'nvim_lsp' },
  --           { name = 'buffer' },
  --           { name = 'path' },
  --           per_filetype = {
  --             codecompanion = { "codecompanion" },
  --           },
  --           -- { name = "codeium" },
  --           -- { name = 'nvim_lsp_signature_help' },
  --           -- { name = 'neorg' },
  --           -- { name = 'orgmode' },
  --         },
  --       })
  --   end
  -- },
}
