-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
---@diagnostic disable: undefined-field
local executable = function(x)
  return vim.fn.executable(x) == 1
end

return {

  {
    -- A Neovim plugin that display prettier diagnostic messages. Display one
    -- line diagnostic messages where the cursor is, with icons and colors.
    -- https://github.com/rachartier/tiny-inline-diagnostic.nvim
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require('tiny-inline-diagnostic').setup({
        -- Style preset for diagnostic messages
        -- Available options:
        -- "modern", "classic", "minimal", "powerline",
        -- "ghost", "simple", "nonerdfont", "amongus"
        preset = "nonerdfont",
        -- Configuration for breaking long messages into separate lines
        options = {
          break_line = {
            -- Enable the feature to break messages after a specific length
            enabled = true,
            -- Number of characters after which to break the line
            after = 30,
          },
        },
      })
      vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
    end
  },

  {
    -- A hackable Markdown, HTML, LaTeX, Typst & YAML previewer for Neovim.
    -- https://github.com/OXY2DEV/markview.nvim
    "OXY2DEV/markview.nvim",
    lazy = false,
    config = function ()

      require("markview").setup({
        preview = {
          icon_provider = "internal", -- "internal", "mini" or "devicons"
        }
      })

      require("markview.extras.editor").setup()

      require("markview.extras.checkboxes").setup({
        --- Default checkbox state(used when adding checkboxes).
        ---@type string
        default = "X",

        --- Changes how checkboxes are removed.
        ---@type
        ---| "disable" Disables the checkbox.
        ---| "checkbox" Removes the checkbox.
        ---| "list_item" Removes the list item markers too.
        remove_style = "disable",

        --- Various checkbox states.
        ---
        --- States are in sets to quickly change between them
        --- when there are a lot of states.
        ---@type string[][]
        states = {
          { " ", "/", "X" },
          { "<", ">" },
          { "?", "!", "*" },
          { '"' },
          { "l", "b", "i" },
          { "S", "I" },
          { "p", "c" },
          { "f", "k", "w" },
          { "u", "d" }
        }
      })
    end,

    -- For blink.cmp's completion
    -- source
    -- dependencies = {
    --     "saghen/blink.cmp"
    -- },
  },

  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function ()
      require("codecompanion").setup({

        display = {
          diff = {
            provider = nil,
          },
        },

        prompt_library = {

          ["Code Expert"] = {
            strategy = "chat",
            description = "Get some special advice from an LLM",
            opts = {
              modes = { "v" },
              short_name = "expert",
              auto_submit = true,
              stop_context_insertion = true,
              user_prompt = true,
            },
            prompts = {
              {
                role = "system",
                content = function(context)
                  return "I want you to act as a senior "
                    .. context.filetype
                    .. " developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples."
                end,
              },
              {
                role = "user",
                content = function(context)
                  local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "I have the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
                end,
                opts = {
                  contains_code = true,
                }
              },
            },
          },

          ["PR body"] = {
            strategy = "chat",
            description = "Create a PR body based on git diff main",
            opts = {
              modes = { "n" },
              short_name = "pr_body",
              auto_submit = true,
              stop_context_insertion = true,
              user_prompt = false,
              placement = "chat", -- or "replace"|"add"|"before"|"chat"
              adapter = {
                name = "gemini",
                model = "gemini-2.5-pro",
              },
            },
            prompts = {
              {
                role = "system",
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

           ["fix grammar"] = {
             strategy = "inline",
             description = "Fix Grammar",
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
                role = "user",
                content = function(_)
                  local diff = vim.fn.system("git diff main")
                  return "Here is the diff:\n\n```diff\n" .. diff .. "\n```\n\n"
                end,
                opts = {
                    contains_code = true,
                },
              },
            },
          },
          ["fix grammar"] = {
            strategy = "inline",
            description = "Fix Grammar",
            opts = {
              modes = { "v" },
              short_name = "fix_grammar",
              auto_submit = true,
              stop_context_insertion = true,
              user_prompt = false,
              placement = "add" -- or "replace"|"add"|"before"|"chat"
            },
            prompts = {
              {
                role = "system",
                content = "You are a grammar fixer, I need from you rewrite the text to make it correct and clear but keep the original tone and intention. Return only the text corrected.",
              },
              {
                role = "user",
                content = function(context)
                  local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "I have the following text:\n\n" .. text .. "\n\n"
                end,
                opts = {
                    contains_code = false,
                },
              },
            },
          },

          ["translate spa"] = {
            strategy = "inline",
            description = "Translate text",
            prompts = {
              {
                role = "system",
                content = "You are a translation assistant. Please translate the provided text between languages while preserving meaning and tone. If the source language isn't specified, detect it and translate to English. If the target language isn't specified, translate to Spanish. Return only the translated text without any explanations.",
              },
              {
                role = "user",
                content = function(context)
                  local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "I have the following text:\n\n" .. text .. "\n\n"
                end,
                opts = {
                  contains_code = false,
                },
              },
            },
          },

          ["translate eng"] = {
            strategy = "inline",
            description = "Translate text",
            prompts = {
              {
                role = "system",
                content = "You are a translation assistant. Please translate the provided text between languages while preserving meaning and tone. If the source language isn't specified, detect it and translate to English. If the target language isn't specified, translate to English. Return only the translated text without any explanations.",
              },
              {
                role = "user",
                content = function(context)
                  local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "I have the following text:\n\n" .. text .. "\n\n"
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
            adapter = "copilot",
          },
          inline = {
            -- adapter = "gemini",
            adapter = "copilot",
          },
          agent = {
            -- adapter = "gemini",
            adapter = "copilot",
          },
        },

        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  -- default = "claude-3.7-sonnet",
                  -- default = "o4-mini",
                  default = "claude-sonnet-4",
                },
              },
            })
          end,

          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              schema = {
                model = {
                  -- default = "gemini-2.0-flash",
                  -- default = "gemini-2.5-flash-preview-04-17",
                  default = "gemini-2.5-pro",
                },
              },
            })
          end,

        },
      })

      vim.keymap.set({ "n", "v" }, "<C-c><C-c>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true, desc = "Show CodeCompanion Actions" })
      vim.keymap.set({ "n", "v" }, "<LocalLeader>c", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true, desc = "Toggle CodeCompanion Chat" })
      vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true, desc = "Add selection to CodeCompanion Chat" })

    end
  },

  {
    "mistricky/codesnap.nvim",
    build = "make",
    opts = {
      save_path = "~/Pictures",
      has_breadcrumbs = true,
      show_workspace = true,
      bg_theme = "bamboo",
      has_line_number = true,
      code_font_family = "CaskaydiaCove Nerd Font",
      watermark_font_family = "Sans Serif",
      watermark = "asdfg8601",
    },
  },

  {
    'altermo/ultimate-autopair.nvim',
    event={'InsertEnter','CmdlineEnter'},
    -- branch='v0.6', --recommended as each new version will have breaking changes
    opts={
      --Config goes here
    },
  },

  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    config = function()
      require("oil").setup({
        view_options = {
          show_hidden = true,
        },
        default_file_explorer = true,
        keymaps = {

          ["<C-s>"] = { "actions.select", opts = { vertical = true } },
          ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
          ["<C-t>"] = { "actions.select", opts = { tab = true } },
          ["cd"] = function ()
              vim.cmd("cd " .. require("oil").get_current_dir())
          end,

          ["~"] = "<cmd>edit $HOME<CR>",

          ["`"] = "actions.tcd",

          ["gd"] = {
            function()
              require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
            end
          },

          ["<C-p>"] = {
            function()
              require("telescope.builtin").find_files({
                cwd = require("oil").get_current_dir(),
                hidden = true,
                exclude = { ".git", "node_modules", ".cache" },
              })
            end,
            mode = "n",
            nowait = true,
            desc = "Find files in the current directory"
          },

          ["go"] = {
            function()
              local oil = require("oil")
              local cwd = oil.get_current_dir()
              local entry = oil.get_cursor_entry()
              if cwd and entry then
                vim.fn.jobstart({ "open", string.format("%s/%s", cwd, entry.name) })
              end
            end
          },

          ["!"] = {
            function ()
              -- Open cmdline with visually selected entries as argument
              -- : <file1> <file2> <file..>
              local oil = require("oil")
              local mode = string.lower(vim.api.nvim_get_mode().mode)
              local bufnr = vim.api.nvim_get_current_buf()
              local name
              local cwd = oil.get_current_dir()
              local items = {}

              local function open_cmdline_with_path(paths, m)
                local rm = ""
                local args = ""
                for _, path in ipairs(paths) do
                  args = args .. " " .. vim.fn.fnameescape(path)
                end
                if m == "v" then
                  rm = "<Del><Del><Del><Del><Del>"
                end
                local escaped = vim.api.nvim_replace_termcodes(":! " .. args .. "<Home>" .. rm .. "<Right>", true, false, true)
                vim.api.nvim_feedkeys(escaped, m, true)
              end

              if mode == "n" then
                local lnum = vim.fn.getpos(".")[2]
                name = oil.get_entry_on_line(bufnr, lnum).name
                table.insert(items, cwd .. name)

              elseif mode == "v" then
                local start = vim.fn.getpos("v")
                local end_ = vim.fn.getpos(".")
                local lnum0 = start[2]
                local lnum1 = end_[2]
                print(lnum0, lnum1)
                for lnum = lnum0, lnum1 do
                  _ = oil.get_entry_on_line(bufnr, lnum)
                  name = oil.get_entry_on_line(bufnr, lnum).name
                  table.insert(items, cwd .. name)
                end
              end
              open_cmdline_with_path(items, mode)
            end
          },

          ["<leader>:"] = {
            "actions.open_cmdline",
            opts = {
              shorten_path = false,
              modify = ":h",
            },
            desc = "Open the command line with the current directory as an argument",
          },

        }
      })

      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },

  {
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    }
  },

  {
    -- git diff view
    'sindrets/diffview.nvim',
    cmd = "DiffviewOpen"
  },

  {
    -- repl support like slime
    "samharju/yeet.nvim",
    dependencies = {
      "stevearc/dressing.nvim", -- optional, provides sane UX
    },
    version = "*",              -- use the latest release, remove for master
    cmd = "Yeet",
    config = function()
      require("yeet").setup({
        -- Send <CR> to channel after command for immediate execution.
        yeet_and_run = true,
        -- Send C-c before execution
        interrupt_before_yeet = false,
        -- Send 'clear<CR>' to channel before command for clean output.
        clear_before_yeet = true,
        -- Enable notify for yeets. Success notifications may be a little
        -- too much if you are using noice.nvim or fidget.nvim
        notify_on_success = true,
        -- Print warning if pane list could not be fetched, e.g. tmux not running.
        warn_tmux_not_running = false,
        -- Window options for cache float
        cache_window_opts = {
          relative = "editor",
          row = (vim.o.lines - 15) * 0.5,
          col = (vim.o.columns - math.ceil(0.6 * vim.o.columns)) * 0.5,
          width = math.ceil(0.6 * vim.o.columns),
          height = 15,
          border = "single",
          title = "Yeet",
        },
      })

      -- Keymaps
      vim.keymap.set('n', '<leader>l', require("yeet").list_cmd, { desc = "Pop command cache open" })
      vim.keymap.set('n', '<leader>yt', require("yeet").select_target, { desc = "Open target selection" })
      vim.keymap.set('n', '\\\\', require("yeet").execute, { desc = "Yeet at something" })
      vim.keymap.set('n', '<leader>yo', require("yeet").toggle_post_write,
        { desc = "Toggle autocommand for yeeting after write" })
      vim.keymap.set('n', '<leader>\\', function()
        require("yeet").execute(nil, { clear_before_yeet = false, interrupt_before_yeet = true })
      end, { desc = "Run command without clearing terminal" })
      vim.keymap.set({ 'n', 'v' }, '<leader>yv', function()
        require("yeet").execute_selection({ clear_before_yeet = false })
      end, { desc = "Yeet visual selection" })
    end
  },

  {
    -- chatgpt like plugin
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = "copilot",
      providers = {
        copilot = {
          -- model = "claude-3.7-sonnet", -- bad
          -- model = "claude-3.5-sonnet",
          -- model = "o4-mini",
          model = "claude-sonnet-4",
          extra_request_body = {
            temperature = 0,
            max_tokens = 81920,
          }
        },
        gemini = {
          -- model = "gemini-2.0-flash"
          -- model = "gemini-2.5-flash",
          -- model = "gemini-2.5-flash-lite-preview-06-17",
          model = "gemini-2.5-pro",
        },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",      -- for providers='copilot'

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
  --   -- live share
  --   "azratul/live-share.nvim",
  --   dependencies = {
  --     "jbyuki/instant.nvim",
  --   },
  --   config = function()
  --     vim.g.instant_username = "asdfg0x2199"
  --     require("live-share").setup({
  --       port_internal = 8765,
  --       max_attempts = 20, -- 5 seconds
  --       service = "serveo.net"
  --     })
  --   end
  -- },

  -- {
  --   'MeanderingProgrammer/markdown.nvim',
  --   name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  --   config = function()
  --     require('render-markdown').setup({
  --       headings = { '#', '#', '#', '#', '#', '#' },
  --       bullet = '○',
  --     })
  --   end,
  -- },

  {
    -- hide key value pairs
    'laytan/cloak.nvim',
    config = function()
      require('cloak').setup({
        enabled = true,
        cloak_character = '*',
        highlight_group = 'Comment',
        cloak_length = nil,
        try_all_patterns = true,
        cloak_telescope = true,
        patterns = {
          {
            file_pattern = { ".autoenv", ".env*" },
            cloak_pattern = "=.+",
          },
        },
      })
    end
  },

  {
    'nvim-pack/nvim-spectre',
    config = function()
      require('spectre').setup()
      vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
      vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
        { desc = "Search current word" })
      vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>',
        { desc = "Search current word" })
      vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
        { desc = "Search on current file" })
    end,

    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  {
    'ishan9299/modus-theme-vim',
    config = function()
      vim.g.modus_yellow_comments = 0
      vim.g.modus_green_strings = 0
      vim.g.modus_faint_syntax = 0
      vim.g.modus_cursorline_intense = 1
      vim.g.modus_termtrans_enable = 1
      vim.g.modus_dim_inactive_window = 0
    end,
  },

  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,
    config = function()
      require("modus-themes").setup({
        -- Theme comes in two styles `modus_operandi` and `modus_vivendi`
        -- `auto` will automatically set style based on background set with vim.o.background
        style = "modus_vivendi",
        variant = "tinted",   -- Theme comes in four variants `default`, `tinted`, `deuteranopia`, and `tritanopia`
        transparent = true,   -- Transparent background (as supported by the terminal)
        dim_inactive = false, -- "non-current" windows are dimmed
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = false },
          keywords = { italic = false },
          functions = {},
          variables = {},
        },
        on_colors = function(colors)
          colors.error = colors.red_faint
        end,
        on_highlights = function(hl, c)
        end,
      })
    end
  },

  -- {
  --   "Rawnly/gist.nvim",
  --   cmd = { "GistCreate", "GistCreateFromFile", "GistsList" },
  --   dependencies = {
  --     {
  --       "samjwill/nvim-unception",
  --       lazy = false,
  --       config = function() vim.g.unception_block_while_host_edits = true end
  --     },
  --   },
  --   config = function()
  --     require("gist").setup({
  --       private = false, -- All gists will be private, you won't be prompted again
  --       clipboard = "+", -- The registry to use for copying the Gist URL
  --       list = {
  --         mappings = {
  --           next_file = "<C-n>",
  --           prev_file = "<C-p>"
  --         }
  --       }
  --     })
  --   end
  -- },

  {
    "robitx/gp.nvim",
    lazy = false,
    init = function()
      require("gp").setup({
        providers = {
          ollama = {
            endpoint = "http://localhost:11434/v1/chat/completions",
          },
        },

        agents = {
          {
            name = "Llama3",
            chat = true,
            command = true,
            provider = "ollama",
            model = { model = "llama3", stream = false },
            system_prompt = "Your are a general AI assistant better than ChatGPT4.",
          },
          {
            name = "ChatGPT4",
            chat = true,
            command = false,
            model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "You are a general AI assistant.\n\n"
                .. "The user provided the additional info about how they would like you to respond:\n\n"
                .. "- If you're unsure don't guess and say you don't know instead.\n"
                .. "- Ask question if you need clarification to provide better answer.\n"
                .. "- Think deeply and carefully from first principles step by step.\n"
                .. "- Zoom out first to see the big picture and then zoom in to details.\n"
                .. "- Use Socratic method to improve your thinking and coding skills.\n"
                .. "- Don't elide any code from your output if the answer requires coding.\n"
                .. "- Take a deep breath; You've got this! Be extremely concise.\n",
          },
          {
            name = "ChatGPT3-5",
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-3.5-turbo", temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "You are a general AI assistant.\n\n"
                .. "The user provided the additional info about how they would like you to respond:\n\n"
                .. "- If you're unsure don't guess and say you don't know instead.\n"
                .. "- Ask question if you need clarification to provide better answer.\n"
                .. "- Think deeply and carefully from first principles step by step.\n"
                .. "- Zoom out first to see the big picture and then zoom in to details.\n"
                .. "- Use Socratic method to improve your thinking and coding skills.\n"
                .. "- Don't elide any code from your output if the answer requires coding.\n"
                .. "- Take a deep breath; You've got this!\n",
          },
          {
            name = "CodeGPT4",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-4o", temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "You are an AI working as a code editor.\n\n"
                .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
                .. "START AND END YOUR ANSWER WITH:\n\n```",
          },
          {
            name = "CodeGPT3-5",
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-3.5-turbo", temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = "You are an AI working as a code editor.\n\n"
                .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
                .. "START AND END YOUR ANSWER WITH:\n\n```",
          },

        },

        hooks = {

          -- GpInspectPlugin provides a detailed inspection of the plugin state
          InspectPlugin = function(plugin, params)
            local bufnr = vim.api.nvim_create_buf(false, true)
            local copy = vim.deepcopy(plugin)
            local key = copy.config.openai_api_key or ""
            copy.config.openai_api_key = key:sub(1, 3) .. string.rep("*", #key - 6) .. key:sub(-3)
            local plugin_info = string.format("Plugin structure:\n%s", vim.inspect(copy))
            local params_info = string.format("Command params:\n%s", vim.inspect(params))
            local lines = vim.split(plugin_info .. "\n" .. params_info, "\n")
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.api.nvim_win_set_buf(0, bufnr)
          end,

          -- GpInspectLog for checking the log file
          InspectLog = function(plugin, _)
            local log_file = plugin.config.log_file
            local buffer = plugin.helpers.get_buffer(log_file)
            if not buffer then
              vim.cmd("e " .. log_file)
            else
              vim.cmd("buffer " .. buffer)
            end
          end,

          -- GpImplement rewrites the provided selection/range based on comments in it
          Implement = function(gp, params)
            local template = "Having following from {{filename}}:\n\n"
                .. "```{{filetype}}\n{{selection}}\n```\n\n"
                .. "Please rewrite this according to the contained instructions."
                .. "\n\nRespond exclusively with the snippet that should replace the selection above."

            local agent = gp.get_command_agent()
            gp.logger.info("Implementing selection with agent: " .. agent.name)

            gp.Prompt(
              params,
              gp.Target.rewrite,
              agent,
              template,
              nil, -- command will run directly without any prompting for user input
              nil  -- no predefined instructions (e.g. speech-to-text from Whisper)
            )
          end,

          -- your own functions can go here, see README for more examples like
          -- :GpExplain, :GpUnitTests.., :GpTranslator etc.

          -- example of making :%GpChatNew a dedicated command which
          -- opens new chat with the entire current buffer as a context
          BufferChatNew = function(gp, _)
            -- call GpChatNew command in range mode on whole buffer
            vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
          end,

          -- example of adding command which opens new chat dedicated for translation
          Translator = function(gp, params)
            local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
            gp.cmd.ChatNew(params, chat_system_prompt)
            -- you can also create a chat with a specific fixed agent like this:
            -- local agent = gp.get_chat_agent("ChatGPT4o")
            -- gp.cmd.ChatNew(params, chat_system_prompt, agent)
          end,

          -- example of adding command which writes unit tests for the selected code
          UnitTests = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
                .. "```{{filetype}}\n{{selection}}\n```\n\n"
                .. "Please respond by writing table driven unit tests for the code above."
            local agent = gp.get_command_agent()
            gp.Prompt(params, gp.Target.enew, agent, template)
          end,

          -- example of adding command which explains the selected code
          Explain = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
                .. "```{{filetype}}\n{{selection}}\n```\n\n"
                .. "Please respond by explaining the code above."
            local agent = gp.get_chat_agent()
            gp.Prompt(params, gp.Target.popup, agent, template)
          end,

          CodeReview = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
                .. "```{{filetype}}\n{{selection}}\n```\n\n"
                .. "Please analyze for code smells and suggest improvements."
            local agent = gp.get_chat_agent()
            gp.Prompt(params, gp.Target.enew("markdown"), agent, template)
          end,

        },
      })
      -- https://github.com/Robitx/gp.nvim?tab=readme-ov-file#4-configuration
    end,
  },

  {
    -- A task runner and job management plugin for Neovim
    -- https://github.com/stevearc/overseer.nvim
    'stevearc/overseer.nvim',
    opts = {},
    event = "VeryLazy",
  },

  {
    "lunarVim/bigfile.nvim",
    opts = {},
  },

  {
    "windwp/nvim-ts-autotag",
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  {
    -- astro
    "virchau13/tree-sitter-astro",
  },

  {
    "folke/zen-mode.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  -- {
  --   -- Highlight text
  --   'Pocco81/HighStr.nvim',
  --   config = function()
  --     local high_str = require("high-str")
  --     high_str.setup({
  --       verbosity = 0,
  --       saving_path = "/tmp/highstr/",
  --       highlight_colors = {
  --         -- color_id = {"bg_hex_code",<"fg_hex_code"/"smart">}
  --         color_0 = { "#0c0d0e", "smart" },           -- Cosmic charcoal
  --         color_1 = { "#e5c07b", "smart" },           -- Pastel yellow
  --         color_2 = { "#7FFFD4", "smart" },           -- Aqua menthe
  --         color_3 = { "#8A2BE2", "smart" },           -- Proton purple
  --         color_4 = { "#FF4500", "smart" },           -- Orange red
  --         color_5 = { "#008000", "smart" },           -- Office green
  --         color_6 = { "#0000FF", "smart" },           -- Just blue
  --         color_7 = { "#FFC0CB", "smart" },           -- Blush pink
  --         color_8 = { "#FFF9E3", "smart" },           -- Cosmic latte
  --         color_9 = { "#7d5c34", "smart" },           -- Fallow brown
  --       }
  --     })
  --
  --     vim.api.nvim_set_keymap("v", "<leader>h1", ":<c-u>HSHighlight 1<CR>", { noremap = true, silent = true, desc = "Highlight text with color 1"})
  --     vim.api.nvim_set_keymap("v", "<leader>h2", ":<c-u>HSHighlight 2<CR>", { noremap = true, silent = true, desc = "Highlight text with color 2"})
  --     vim.api.nvim_set_keymap("v", "<leader>h3", ":<c-u>HSHighlight 3<CR>", { noremap = true, silent = true, desc = "Highlight text with color 3"})
  --     vim.api.nvim_set_keymap("v", "<leader>h4", ":<c-u>HSHighlight 4<CR>", { noremap = true, silent = true, desc = "Highlight text with color 4"})
  --     vim.api.nvim_set_keymap("v", "<leader>h0", ":<c-u>HSRmHighlight<CR>", { noremap = true, silent = true, desc = "Remove text highlight"})
  --
  --   end
  -- },

  {
    -- scala lsp
    'scalameta/nvim-metals',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local metals_config = require("metals").bare_config()

      -- Example of settings
      metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      }

      -- metals_config.init_options.statusBarProvider = "on"
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
      local dap = require("dap")
      dap.configurations.scala = {
        {
          type = "scala",
          request = "launch",
          name = "RunOrTest",
          metals = {
            runType = "runOrTestFile",
            --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
          },
        },
        {
          type = "scala",
          request = "launch",
          name = "Test Target",
          metals = {
            runType = "testTarget",
          },
        },
      }

      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()
      end

      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end
  },

  'junegunn/vim-easy-align',
  'alec-gibson/nvim-tetris',

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
      }
    }
  },


  {
    -- database support in vim
    'tpope/vim-dadbod',
    dependencies = {
      'kristijanhusak/vim-dadbod-ui',
    }
  },

  'tpope/vim-repeat', -- better repeat
  'tpope/vim-speeddating',


  {
    'tpope/vim-unimpaired',
  },

  {
    'goerz/jupytext.vim',
    config = function()
      vim.g.jupytext_fmt = 'py:percent'
    end
  },

  'szw/vim-maximizer',
  'RRethy/vim-illuminate',

  {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          -- Conform will run multiple formatters sequentially
          python = { "isort -m3", "black -l79", },
          -- Use a sub-list to run only the first available formatter
          javascript = { { "prettierd", "prettier" } },
          sh = { "beautysh" },
        },
      })
      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        require("conform").format({ async = true, lsp_fallback = true, range = range })
      end, { range = true })
    end
  },

  -- {
  --   "NTBBloodbath/rest.nvim",
  --   enable = executable "jq",
  --   ft = { "http" },
  --   dependencies = {
  --     {
  --       "vhyrro/luarocks.nvim",
  --       priority = 1000,
  --       config = true,
  --     },
  --   },
  --   config = function()
  --     require("rest-nvim").setup({
  --       client = "curl",
  --       env_file = ".env",
  --       env_pattern = "\\.env$",
  --       env_edit_command = "tabedit",
  --       encode_url = true,
  --       skip_ssl_verification = false,
  --       custom_dynamic_variables = {},
  --       logs = {
  --         level = "info",
  --         save = true,
  --       },
  --       result = {
  --         split = {
  --           horizontal = false,
  --           in_place = false,
  --           stay_in_current_window_after_split = true,
  --         },
  --         behavior = {
  --           decode_url = true,
  --           show_info = {
  --             url = true,
  --             headers = true,
  --             http_info = true,
  --             curl_command = true,
  --           },
  --           statistics = {
  --             enable = true,
  --             ---@see https://curl.se/libcurl/c/curl_easy_getinfo.html
  --             stats = {
  --               { "total_time",      title = "Time taken:" },
  --               { "size_download_t", title = "Download size:" },
  --             },
  --           },
  --           formatters = {
  --             json = "jq",
  --             html = function(body)
  --               if vim.fn.executable("tidy") == 0 then
  --                 return body, { found = false, name = "tidy" }
  --               end
  --               local fmt_body = vim.fn.system({
  --                 "tidy",
  --                 "-i",
  --                 "-q",
  --                 "--tidy-mark", "no",
  --                 "--show-body-only", "auto",
  --                 "--show-errors", "0",
  --                 "--show-warnings", "0",
  --                 "-",
  --               }, body):gsub("\n$", "")
  --
  --               return fmt_body, { found = true, name = "tidy" }
  --             end,
  --           },
  --         },
  --       },
  --       highlight = {
  --         enable = true,
  --         timeout = 750,
  --       },
  --       ---@see vim.keymap.set
  --       keybinds = {
  --         {
  --           "<localleader>rr", ":Rest run", "Run request under the cursor",
  --         },
  --         {
  --           "<localleader>rl", ":Rest run last", "Re-run latest request",
  --         },
  --       },
  --     })
  --     -- vim.api.nvim_set_keymap("n", "<leader>rr", "<Plug>RestNvim", { noremap = true, silent = true })
  --   end,
  -- },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-vim-test",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
    },
    init = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            dap = { justMyCode = false },
            args = { "--capture", "no" },
            runner = "pytest",
            -- python = ".venv/bin/python",

          }),
          -- log_level = vim.log.levels.DEBUG,
        }
      })
    end,
    config = function()
      vim.keymap.set('n', '<leader>tn', function() require("neotest").run.run() end,
        { noremap = true, desc = 'Run nearest test' })
      vim.keymap.set('n', '<leader>tf', function() require("neotest").run.run(vim.fn.expand("%")) end,
        { noremap = true, desc = 'Run current file tests' })
      vim.keymap.set('n', '<leader>to', function() require("neotest").output_panel.toggle() end,
        { noremap = true, desc = 'Toggle output panel' })
      vim.keymap.set('n', '<leader>tl', function() require("neotest").run.run_last() end,
        { noremap = true, desc = 'Run last test' })
      vim.keymap.set('n', '<leader>td', function() require("neotest").run.run({ strategy = "dap" }) end,
        { noremap = true, desc = 'Run test debug mode' })
    end
  },

  -- {
  --   "klen/nvim-test",
  --   config = function()
  --     require('nvim-test').setup({})
  --   end
  -- },

  { 'mracos/mermaid.vim' },

  { 'mzlogin/vim-markdown-toc', },

  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    config = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      'theHamsta/nvim-dap-virtual-text',
      'mfussenegger/nvim-dap-python',
      'leoluz/nvim-dap-go',
    },
    config = function()
      require("dapui").setup()
      require("nvim-dap-virtual-text").setup({})
      require("dap-python").setup()
      require('dap-go').setup({
        dap_configurations = {
          {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
        delve = {
          path = "dlv",
          initialize_timeout_sec = 20,
          port = "${port}",
          args = {},
          build_flags = "",
        },
      })

      local dap = require('dap')
      vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
        { noremap = true, desc = 'dap set breakpoint condition' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { noremap = true, desc = 'dap toggle breakpoint' })
      vim.keymap.set('n', '<leader>dc', dap.continue, { noremap = true, desc = 'dap continue' })
      vim.keymap.set('n', '<leader>dh', dap.step_out, { noremap = true, desc = 'dap step out ←' })
      vim.keymap.set('n', '<leader>dl', dap.step_into, { noremap = true, desc = 'dap step into →' })
      vim.keymap.set('n', '<leader>dk', dap.step_back, { noremap = true, desc = 'dap step back ↑' })
      vim.keymap.set('n', '<leader>dj', dap.step_over, { noremap = true, desc = 'dap step over ↓' })
      vim.keymap.set('n', '<leader>de', dap.repl.open, { noremap = true, desc = 'dap open repl' })
      vim.keymap.set('n', '<leader>dr', dap.run_last, { noremap = true, desc = 'dap run last' })
      vim.keymap.set('n', '<leader>dq', dap.disconnect, { noremap = true, desc = 'dap disconnect' })

      local dapui = require('dapui')
      vim.keymap.set('n', '<leader>du', dapui.toggle, { noremap = true, desc = 'toggle dap ui' })
      vim.keymap.set('n', '<leader>do', dapui.open, { noremap = true, desc = 'toggle dap ui' })
      vim.keymap.set('n', '<leader>dx', dapui.close, { noremap = true, desc = 'toggle dap ui' })
    end,
  },


  {
    -- Spawning interactive processes
    'tpope/vim-dispatch',
  },

  -- {
  --   'tpope/vim-markdown',
  -- },

  {
    -- NOTE: this was causing lost the startup message
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()',
    init = function ()
      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require('go.format').goimports()
        end,
        group = format_sync_grp,
      })
      require('go').setup()
    end,
  },

  -- {
  --   'echasnovski/mini.nvim',
  --   init = function()
  --     require('mini.ai').setup({ n_lines = 500 })
  --     require('mini.operators').setup()
  --     -- require('mini.statusline').setup()
  --     -- require('mini.surround').setup()
  --     require('mini.map').setup(
  --       {
  --         integrations = nil,
  --         symbols = {
  --           encode = require('mini.map').gen_encode_symbols.dot('3x2'),
  --           scroll_line = '█',
  --           scroll_view = '┃',
  --         },
  --         window = {
  --           focusable = false,
  --           side = 'right',
  --           show_integration_count = true,
  --           width = 12,
  --           winblend = 25,
  --           zindex = 10,
  --         },
  --       }
  --     )
  --     require('mini.files').setup({
  --       options = {
  --         permanent_delete = false,
  --         use_as_default_explorer = false,
  --       },
  --       mappings = {
  --           close       = 'q',
  --           go_in       = 'l',
  --           go_in_plus  = 'L',
  --           go_out      = 'h',
  --           go_out_plus = 'H',
  --           reset       = '<C-r>',
  --           reveal_cwd  = '@',
  --           show_help   = 'g?',
  --           synchronize = '=',
  --           trim_left   = '<',
  --           trim_right  = '>',
  --         },
  --       windows = {
  --         max_number = math.huge,
  --         preview = false,
  --         width_focus = 50,
  --         width_nofocus = 15,
  --         width_preview = 25,
  --       },
  --
  --     })
  --
  --     vim.keymap.set("n", "<leader>mf", MiniFiles.open, {desc = "Open file explorer"})
  --     vim.keymap.set("n", "<leader>mm", MiniMap.toggle, {desc = "Toggle Mini Map"})
  --
  --   end,
  -- },
  --
  -- {
  --   "monkoose/neocodeium",
  --   event = "VeryLazy",
  --   config = function()
  --     local neocodeium = require("neocodeium")
  --     neocodeium.setup()
  --     vim.keymap.set("i", "<A-f>", neocodeium.accept)
  --   end,
  -- },
  --
  -- {
  --   "Exafunction/codeium.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "hrsh7th/nvim-cmp",
  --   },
  --   enable = false,
  --   config = function()
  --     require("codeium").setup({
  --     })
  --   end
  -- },

}
-- vim: ts=2 sts=2 sw=2 et tw=0
