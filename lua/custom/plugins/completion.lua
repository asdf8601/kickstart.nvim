return {
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
  { -- Autocompletion
    'saghen/blink.cmp',
    -- event = 'VimEnter',
    version = '1.*',
    optional = true,
    dependencies = {
      'fang2hou/blink-copilot',
      'Kaiser-Yang/blink-cmp-avante',
      'disrupted/blink-cmp-conventional-commits',
      'Kaiser-Yang/blink-cmp-git',
      'bydlw98/blink-cmp-env',
      -- 'asdf8601/blink-cmp-jira',
      { dir = '~/github.com/asdf8601/blink-cmp-jira' },
    },
    opts = {
      appearance = { nerd_font_variant = 'mono' },
      completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
      keymap = {
        preset = 'default',
        ['<C-q>'] = {
          function(cmp)
            cmp.show { providers = { 'jira' } }
          end,
        },
      },
      sources = {
        default = { 'jira', 'copilot', 'lsp', 'path', 'buffer', 'avante', 'cvcm', 'git', 'env' },
        providers = {
          jira = {
            name = 'blink-jira',
            module = 'blink-jira',
            opts = {
              jira_project = 'GC',
              jira_status = { 'In Progress', 'To Do', 'In Review' },
              max_results = 50,
              cache_duration = 10,
              -- debug = true,
            },
          },
          env = {
            name = 'Env',
            module = 'blink-cmp-env',
            opts = {
              -- item_kind = require('blink.cmp.types').CompletionItemKind.Variable,
              show_braces = false,
              show_documentation_window = true,
            },
          },
          git = {
            module = 'blink-cmp-git',
            name = 'Git',
            -- opts = { },
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
            score_offset = 100,
            async = true,
          },
        },
      },
      -- snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
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
                    default = 'claude-sonnet-4',
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
      provider = 'gemini',
      providers = {
        copilot = {
          -- model = "claude-3.7-sonnet", -- bad
          -- model = "claude-3.5-sonnet",
          -- model = "o4-mini",
          model = 'claude-sonnet-4',
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

      -- {
      --   -- support for image pasting
      --   "HakonHarnes/img-clip.nvim",
      --   event = "VeryLazy",
      --   opts = {
      --     -- recommended settings
      --     default = {
      --       embed_image_as_base64 = false,
      --       prompt_for_file_name = false,
      --       drag_and_drop = {
      --         insert_mode = true,
      --       },
      --       -- required for Windows users
      --       use_absolute_path = true,
      --     },
      --   },
      -- },

      -- {
      --   -- Make sure to set this up properly if you have lazy=true
      --   'MeanderingProgrammer/render-markdown.nvim',
      --   opts = {
      --     file_types = { "markdown", "Avante" },
      --   },
      --   ft = { "markdown", "Avante" },
      -- },
    },
  },

  -- {
  --   "robitx/gp.nvim",
  --   lazy = false,
  --   init = function()
  --     require("gp").setup({
  --       providers = {
  --         ollama = {
  --           endpoint = "http://localhost:11434/v1/chat/completions",
  --         },
  --       },
  --
  --       agents = {
  --         {
  --           name = "Llama3",
  --           chat = true,
  --           command = true,
  --           provider = "ollama",
  --           model = { model = "llama3", stream = false },
  --           system_prompt = "Your are a general AI assistant better than ChatGPT4.",
  --         },
  --         {
  --           name = "ChatGPT4",
  --           chat = true,
  --           command = false,
  --           model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
  --           -- system prompt (use this to specify the persona/role of the AI)
  --           system_prompt = "You are a general AI assistant.\n\n"
  --               .. "The user provided the additional info about how they would like you to respond:\n\n"
  --               .. "- If you're unsure don't guess and say you don't know instead.\n"
  --               .. "- Ask question if you need clarification to provide better answer.\n"
  --               .. "- Think deeply and carefully from first principles step by step.\n"
  --               .. "- Zoom out first to see the big picture and then zoom in to details.\n"
  --               .. "- Use Socratic method to improve your thinking and coding skills.\n"
  --               .. "- Don't elide any code from your output if the answer requires coding.\n"
  --               .. "- Take a deep breath; You've got this! Be extremely concise.\n",
  --         },
  --         {
  --           name = "ChatGPT3-5",
  --           chat = true,
  --           command = false,
  --           -- string with model name or table with model name and parameters
  --           model = { model = "gpt-3.5-turbo", temperature = 1.1, top_p = 1 },
  --           -- system prompt (use this to specify the persona/role of the AI)
  --           system_prompt = "You are a general AI assistant.\n\n"
  --               .. "The user provided the additional info about how they would like you to respond:\n\n"
  --               .. "- If you're unsure don't guess and say you don't know instead.\n"
  --               .. "- Ask question if you need clarification to provide better answer.\n"
  --               .. "- Think deeply and carefully from first principles step by step.\n"
  --               .. "- Zoom out first to see the big picture and then zoom in to details.\n"
  --               .. "- Use Socratic method to improve your thinking and coding skills.\n"
  --               .. "- Don't elide any code from your output if the answer requires coding.\n"
  --               .. "- Take a deep breath; You've got this!\n",
  --         },
  --         {
  --           name = "CodeGPT4",
  --           chat = false,
  --           command = true,
  --           -- string with model name or table with model name and parameters
  --           model = { model = "gpt-4o", temperature = 0.8, top_p = 1 },
  --           -- system prompt (use this to specify the persona/role of the AI)
  --           system_prompt = "You are an AI working as a code editor.\n\n"
  --               .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
  --               .. "START AND END YOUR ANSWER WITH:\n\n```",
  --         },
  --         {
  --           name = "CodeGPT3-5",
  --           chat = false,
  --           command = true,
  --           -- string with model name or table with model name and parameters
  --           model = { model = "gpt-3.5-turbo", temperature = 0.8, top_p = 1 },
  --           -- system prompt (use this to specify the persona/role of the AI)
  --           system_prompt = "You are an AI working as a code editor.\n\n"
  --               .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
  --               .. "START AND END YOUR ANSWER WITH:\n\n```",
  --         },
  --
  --       },
  --
  --       hooks = {
  --
  --         -- GpInspectPlugin provides a detailed inspection of the plugin state
  --         InspectPlugin = function(plugin, params)
  --           local bufnr = vim.api.nvim_create_buf(false, true)
  --           local copy = vim.deepcopy(plugin)
  --           local key = copy.config.openai_api_key or ""
  --           copy.config.openai_api_key = key:sub(1, 3) .. string.rep("*", #key - 6) .. key:sub(-3)
  --           local plugin_info = string.format("Plugin structure:\n%s", vim.inspect(copy))
  --           local params_info = string.format("Command params:\n%s", vim.inspect(params))
  --           local lines = vim.split(plugin_info .. "\n" .. params_info, "\n")
  --           vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  --           vim.api.nvim_win_set_buf(0, bufnr)
  --         end,
  --
  --         -- GpInspectLog for checking the log file
  --         InspectLog = function(plugin, _)
  --           local log_file = plugin.config.log_file
  --           local buffer = plugin.helpers.get_buffer(log_file)
  --           if not buffer then
  --             vim.cmd("e " .. log_file)
  --           else
  --             vim.cmd("buffer " .. buffer)
  --           end
  --         end,
  --
  --         -- GpImplement rewrites the provided selection/range based on comments in it
  --         Implement = function(gp, params)
  --           local template = "Having following from {{filename}}:\n\n"
  --               .. "```{{filetype}}\n{{selection}}\n```\n\n"
  --               .. "Please rewrite this according to the contained instructions."
  --               .. "\n\nRespond exclusively with the snippet that should replace the selection above."
  --
  --           local agent = gp.get_command_agent()
  --           gp.logger.info("Implementing selection with agent: " .. agent.name)
  --
  --           gp.Prompt(
  --             params,
  --             gp.Target.rewrite,
  --             agent,
  --             template,
  --             nil, -- command will run directly without any prompting for user input
  --             nil  -- no predefined instructions (e.g. speech-to-text from Whisper)
  --           )
  --         end,
  --
  --         -- your own functions can go here, see README for more examples like
  --         -- :GpExplain, :GpUnitTests.., :GpTranslator etc.
  --
  --         -- example of making :%GpChatNew a dedicated command which
  --         -- opens new chat with the entire current buffer as a context
  --         BufferChatNew = function(gp, _)
  --           -- call GpChatNew command in range mode on whole buffer
  --           vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
  --         end,
  --
  --         -- example of adding command which opens new chat dedicated for translation
  --         Translator = function(gp, params)
  --           local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
  --           gp.cmd.ChatNew(params, chat_system_prompt)
  --           -- you can also create a chat with a specific fixed agent like this:
  --           -- local agent = gp.get_chat_agent("ChatGPT4o")
  --           -- gp.cmd.ChatNew(params, chat_system_prompt, agent)
  --         end,
  --
  --         -- example of adding command which writes unit tests for the selected code
  --         UnitTests = function(gp, params)
  --           local template = "I have the following code from {{filename}}:\n\n"
  --               .. "```{{filetype}}\n{{selection}}\n```\n\n"
  --               .. "Please respond by writing table driven unit tests for the code above."
  --           local agent = gp.get_command_agent()
  --           gp.Prompt(params, gp.Target.enew, agent, template)
  --         end,
  --
  --         -- example of adding command which explains the selected code
  --         Explain = function(gp, params)
  --           local template = "I have the following code from {{filename}}:\n\n"
  --               .. "```{{filetype}}\n{{selection}}\n```\n\n"
  --               .. "Please respond by explaining the code above."
  --           local agent = gp.get_chat_agent()
  --           gp.Prompt(params, gp.Target.popup, agent, template)
  --         end,
  --
  --         CodeReview = function(gp, params)
  --           local template = "I have the following code from {{filename}}:\n\n"
  --               .. "```{{filetype}}\n{{selection}}\n```\n\n"
  --               .. "Please analyze for code smells and suggest improvements."
  --           local agent = gp.get_chat_agent()
  --           gp.Prompt(params, gp.Target.enew("markdown"), agent, template)
  --         end,
  --
  --       },
  --     })
  --     -- https://github.com/Robitx/gp.nvim?tab=readme-ov-file#4-configuration
  --   end,
  -- },
}
