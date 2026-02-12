return {
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
            adapter = 'gemini',
            -- adapter = 'copilot',
          },
          inline = {
            adapter = 'gemini',
            -- adapter = 'copilot',
          },
          agent = {
            adapter = 'gemini',
            -- adapter = 'copilot',
          },
        },
        interactions = {
          chat = {
            adapter = {
              name = 'opencode',
              model = 'google-vertex/gemini-3-flash-preview',
            },
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
                    -- default = 'claude-sonnet-4.5',
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
                    -- default = 'gemini-3-pro',
                    default = 'gemini-3-flash-preview',
                    flash = 'gemini-3-flash-preview',
                    pro = 'gemini-3-pro-preview',
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
}
