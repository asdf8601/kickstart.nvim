local build_snippets = function()
  local ls = require('luasnip')
  local ps = ls.parser.parse_snippet
  ls.filetype_extend("mdx",   { "md" })
  ls.filetype_extend("astro", { "md" })

  ls.add_snippets("md", { ps("mer", "<Mermaid>\n\t$1\n</Mermaid>") })
  ls.add_snippets("md", { ps("dl", "<dl>\n\t<dt>$1</dt>\n\t<dd>$2</dd>\n</dl>") })
  ls.add_snippets("md", { ps("dt", "<dt>$1</dt>\n<dd>$2</dd>") })
  ls.add_snippets("md", { ps("gi", "<GridItem cols={1}>\n\t$1\n</GridItem>") })
  ls.add_snippets("md", { ps("gr", "<Grid cols={2}>\n\t$1\n</Grid>") })
  ls.add_snippets("md", { ps("card", "<Card>\n\t$1\n</Card>") })
end


return {
  { -- Autocompletion
    'saghen/blink.cmp',
    -- event = 'VimEnter',
    version = '1.*',
    optional = true,
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        opts = {
            history = true,
            delete_check_events = 'TextChanged',
        },
        config = function (_, opts)
          require('luasnip').setup(opts)
          build_snippets()
        end,
      },
      'fang2hou/blink-copilot',
      'Kaiser-Yang/blink-cmp-avante',
      'disrupted/blink-cmp-conventional-commits',
      'bydlw98/blink-cmp-env',
      'Kaiser-Yang/blink-cmp-git',
      'asdf8601/blink-cmp-jira',
      { dir = '~/github.com/asdf8601/blink-cmp-jira' },
    },
    opts = {
      appearance = { nerd_font_variant = 'mono' },
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 100 } },
      keymap = {
        preset = 'default',
        -- ['<C-k>'] = nil,
        -- ['<C-q>'] = { function(cmp) cmp.show { providers = { 'jira' } } end, },
        -- ['<C-g><C-g>'] = { function(cmp) cmp.show { providers = { 'copilot' } } end, },
      },
      sources = {
        default = { 'snippets', 'lsp', 'path', 'buffer', 'copilot' },
        -- default = { 'lsp', 'path', 'buffer', 'avante', 'cvcm', 'env' },
        -- default = { 'snippets', 'lsp', 'path', 'buffer', 'jira', 'copilot', 'avante', 'cvcm', 'git', 'env' },
        -- default = { 'snippets', 'lsp', 'path', 'buffer', 'jira', 'copilot', 'avante', 'cvcm', 'git', 'env' },
        providers = {
          buffer = {
            -- make it cheap and faster
            min_keyword_length = 3,
            max_items = 50,
            score_offset = -5,
            async = true,
            opts = {
              -- solo el buffer actual (no todos los visibles)
              get_bufnrs = function() return { vim.api.nvim_get_current_buf() } end,
              -- corta tamaños grandes
              max_total_buffer_size = 200000,  -- 200KB
              max_async_buffer_size = 150000,  -- por buffer
              use_cache = true,
            },
          },
          jira = {
            name = 'blink-cmp-jira',
            module = 'blink-cmp-jira',
            async = true,
            opts = {
              trigger_character = 'GC-',
              jira_project = 'GC',
              jira_status = { 'In Progress', 'To Do', 'In Review' },
              max_results = 50,
              cache_duration = 300,
            },
          },
          git = {
            module = 'blink-cmp-git',
            name = 'Git',
            opts = {},
            async = true,
          },
          env = {
            name = 'Env',
            module = 'blink-cmp-env',
            async = true,
            opts = {
              -- item_kind = require('blink.cmp.types').CompletionItemKind.Variable,
              show_braces = false,
              show_documentation_window = true,
            },
          },
          cvcm = {
            name = 'Conventional Commits',
            module = 'blink-cmp-conventional-commits',
            enabled = function()
              return vim.bo.filetype == 'gitcommit'
            end,
          },
          avante = {
            module = 'blink-cmp-avante',
            name = 'Avante',
            -- opts = {},
          },
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            score_offset = 2,
            async = true,
          },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = {
        -- implementation = 'lua'
        -- implementation = 'prefer_rust',
        implementation = 'prefer_rust_with_warning',
      },
      signature = { enabled = true },
    },
  },
}
