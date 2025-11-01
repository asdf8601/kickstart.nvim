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

  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('codecompanion').setup {

        display = {
          diff = {
            provider = nil,
          },
        },

        prompt_library = {

          ['Code Expert'] = {
            strategy = 'chat',
            description = 'Get some special advice from an LLM',
            opts = {
              modes = { 'v' },
              short_name = 'expert',
              auto_submit = true,
              stop_context_insertion = true,
              user_prompt = true,
            },
            prompts = {
              {
                role = 'system',
                content = function(context)
                  return 'I want you to act as a senior '
                    .. context.filetype
                    .. ' developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples.'
                end,
              },
              {
                role = 'user',
                content = function(context)
                  local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
                  return 'I have the following code:\n\n```' .. context.filetype .. '\n' .. text .. '\n```\n\n'
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },

          ['PR body'] = {
            strategy = 'chat',
            description = 'Create a PR body based on git diff main',
            opts = {
              modes = { 'n' },
              short_name = 'pr_body',
              auto_submit = true,
              stop_context_insertion = true,
              user_prompt = false,
              placement = 'chat', -- or "replace"|"add"|"before"|"chat"
              adapter = {
                name = 'gemini',
                model = 'gemini-2.5-pro',
              },
            },
            prompts = {
              {
                role = 'system',
                content = [[
                  <goal>
                  You’re an assistant that takes a Git diff and writes a short,
                  casual PR description without jargon. Don't forget to mention
                  other relevant changes.
                  Big changes don't have to be the only ones you comment on.
                  Be very concise and simple and use simple words.
                  Do not include ornamental text.
                  Do not include suggestions nor improvements.

                  Output format:
                  1. **Quick summary**: one sentence.
                  2. **Main changes**: bullet list grouped by file or feature.
                  3. **Optional details**: for anything special.
                  4. **How to test**: quick commands or steps.
                  </goal>

                  <input>

                  ```diff
                  diff --git c/README.md w/README.md
                  index a678f9c..8cf4dc0 100644
                  --- c/README.md
                  +++ w/README.md
                  + This an example:
                  + ```bash
                  + ash setup
                  + ash run
                  + ```
                  </input>

                  <output>
                  ## Quick summary:
                  - Improved docs and scripts.

                  ## Main changes:
                  - README.md: simplified text and added example.

                  ## Optional details:
                  - Added alias `ash` for `agora.sh`.

                  ## How to test:
                  - Run the following commands:
                  ```bash
                  ash setup
                  ash run
                  ```
                  </output>

                  ```
                  </input>

                  <output>
                  Return:

                  Quick summary:
                      •	Improved docs and scripts.

                  Main changes:
                      •	README.md: simplified text and added Quick Start.
                      •	agora.sh: added alias ash, colors, error handling, improved fzf.
                      •	.gitignore: added Python rules.

                  How to test:

                  ```
                  ash setup
                  ash run
                  ```
                  </output>

                  ]],
              },
              {
                role = 'user',
                content = function(_)
                  local diff = vim.fn.system 'git diff main'
                  return 'Here is the diff:\n\n```diff\n' .. diff .. '\n```\n\n'
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ['fix grammar'] = {
            strategy = 'inline',
            description = 'Fix Grammar',
            opts = {
              modes = { 'v' },
              short_name = 'fix_grammar',
              auto_submit = true,
              stop_context_insertion = true,
              user_prompt = false,
              placement = 'add', -- or "replace"|"add"|"before"|"chat"
            },
            prompts = {
              {
                role = 'system',
                content = 'You are a grammar fixer, I need from you rewrite the text to make it correct and clear but keep the original tone and intention. Return only the text corrected.',
              },
              {
                role = 'user',
                content = function(context)
                  local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
                  return 'I have the following text:\n\n' .. text .. '\n\n'
                end,
                opts = {
                  contains_code = false,
                },
              },
            },
          },

          ['translate spa'] = {
            strategy = 'inline',
            description = 'Translate text',
            prompts = {
              {
                role = 'system',
                content = "You are a translation assistant. Please translate the provided text between languages while preserving meaning and tone. If the source language isn't specified, detect it and translate to English. If the target language isn't specified, translate to Spanish. Return only the translated text without any explanations.",
              },
              {
                role = 'user',
                content = function(context)
                  local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
                  return 'I have the following text:\n\n' .. text .. '\n\n'
                end,
                opts = {
                  contains_code = false,
                },
              },
            },
          },

          ['translate eng'] = {
            strategy = 'inline',
            description = 'Translate text',
            prompts = {
              {
                role = 'system',
                content = "You are a translation assistant. Please translate the provided text between languages while preserving meaning and tone. If the source language isn't specified, detect it and translate to English. If the target language isn't specified, translate to English. Return only the translated text without any explanations.",
              },
              {
                role = 'user',
                content = function(context)
                  local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
                  return 'I have the following text:\n\n' .. text .. '\n\n'
                end,
                opts = {
                  contains_code = false,
                },
              },
            },
          },
        },

        strategies = {
          chat = {
            -- adapter = "gemini",
            adapter = 'copilot',
          },
          inline = {
            -- adapter = "gemini",
            adapter = 'copilot',
          },
          agent = {
            -- adapter = "gemini",
            adapter = 'copilot',
          },
        },

        adapters = {
          http = {
            copilot = function()
              return require('codecompanion.adapters.http').extend('copilot', {
                schema = {
                  model = {
                    -- default = "claude-3.7-sonnet",
                    -- default = "o4-mini",
                    -- default = 'claude-sonnet-4',
                    default = 'claude-sonnet-4.5',
                  },
                },
              })
            end,

            gemini = function()
              return require('codecompanion.adapters.http').extend('gemini', {
                schema = {
                  model = {
                    -- default = "gemini-2.0-flash",
                    -- default = "gemini-2.5-flash-preview-04-17",
                    default = 'gemini-2.5-pro',
                  },
                },
              })
            end,
          },
        },
      }

      vim.keymap.set({ 'n', 'v' }, '<C-c><C-c>', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true, desc = 'Show CodeCompanion Actions' })
      vim.keymap.set({ 'n', 'v' }, '<LocalLeader>c', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true, desc = 'Toggle CodeCompanion Chat' })
      vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true, desc = 'Add selection to CodeCompanion Chat' })
    end,
  },

  {
    -- chatgpt like plugin
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = 'copilot',
      providers = {
        copilot = {
          -- model = "claude-3.7-sonnet", -- bad
          -- model = "claude-3.5-sonnet",
          -- model = "o4-mini",
          model = 'claude-sonnet-4.5',
          extra_request_body = {
            temperature = 0,
            max_tokens = 81920,
          },
        },
        gemini = {
          -- model = "gemini-2.0-flash"
          -- model = "gemini-2.5-flash-lite-preview-06-17",
          -- model = "gemini-2.5-pro",
          model = 'gemini-2.5-flash',
          extra_request_body = {
            temperature = 0,
            max_tokens = 81920,
          },
        },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'

      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          -- file_types = { 'markdown', 'Avante' },
          file_types = { 'Avante' },
        },
        -- ft = { 'markdown', 'Avante' },
        ft = { 'Avante' },
      },
    },
  },
}
