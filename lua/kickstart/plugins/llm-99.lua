return {
  {
    'ThePrimeagen/99',
    -- stylua: ignore start
    keys = {
      -- visual selection only in v mode so an old selection is never reused
      { '<leader>9v', function() require('99').visual {} end, mode = 'v', desc = '99 visual' },
      { '<leader>9x', function() require('99').stop_all_requests() end, desc = '99 stop all requests' },
      { '<leader>9s', function() require('99').search {} end, desc = '99 search' },
      { '<leader>9m', function() require('99.extensions.telescope').select_model() end, desc = '99 select model' },
      { '<leader>9.', function() require('99').vibe {} end, desc = '99 vibe' },
      { '<leader>9/', function() require('99').tutorial {} end, desc = '99 tutorial' },
      { '<leader>9i', function() require('99').info() end, desc = '99 info' },
      { '<leader>9o', function() require('99').open() end, desc = '99 open last result' },
      { '<leader>9l', function() require('99').view_logs() end, desc = '99 view logs' },
      { '<leader>9c', function() require('99').clear_previous_requests() end, desc = '99 clear previous requests' },
      { '<leader>9t', function() require('99').visual { additional_prompt = 'convert this into a table-driven test using testify require and the unit build tag' } end, mode = 'v', desc = '99 to table test' },
      { '<leader>9e', function() require('99').visual { additional_prompt = 'wrap each error with fmt.Errorf and %w adding context, do not change the logic' } end, mode = 'v', desc = '99 wrap errors' },
      {
        '<leader>9d',
        function()
          require('99').search {
            additional_prompt = [[
              run `make test` and debug the test failures and provide me a
              concise set of steps where the tests are breaking
              ]],
          }
        end,
        desc = '99 debug make test failures',
      },
    },
    -- stylua: ignore end
    config = function()
      local _99 = require '99'

      -- For logging that is to a file if you wish to trace through requests
      -- for reporting bugs, i would not rely on this, but instead the provided
      -- logging mechanisms within 99.  This is for more debugging purposes
      local cwd = vim.uv.cwd()
      local basename = vim.fs.basename(cwd)

      -- upstream hardcodes a stale 4.x list because the claude CLI cannot list models
      _99.Providers.ClaudeCodeProvider.fetch_models = function(callback)
        callback({
          'sonnet',
          'opus',
          'fable',
          'claude-fable-5-1',
          'claude-opus-5-5',
          'claude-sonnet-5-5',
          'claude-haiku-4-5',
        }, nil)
      end

      _99.setup {
        -- claude code carries the Claude subscription via OAuth; opencode has no anthropic credential
        provider = _99.Providers.ClaudeCodeProvider, -- default: OpenCodeProvider
        model = 'sonnet', -- alias to the latest sonnet, the CLI also takes 'opus' and 'fable'
        -- provider = _99.Providers.OpenCodeProvider,
        -- model = 'anthropic/claude-haiku-4-5',
        logger = {
          level = _99.DEBUG,
          path = '/tmp/' .. basename .. '.99.debug',
          print_on_error = true,
        },
        -- When setting this to something that is not inside the CWD tools
        -- such as claude code or opencode will have permission issues
        -- and generation will fail refer to tool documentation to resolve
        -- https://opencode.ai/docs/permissions/#external-directories
        -- https://code.claude.com/docs/en/permissions#read-and-edit
        tmp_dir = './tmp',

        --- Completions: #rules and @files in the prompt buffer
        completion = {
          -- I am going to disable these until i understand the
          -- problem better.  Inside of cursor rules there is also
          -- application rules, which means i need to apply these
          -- differently
          -- cursor_rules = "<custom path to cursor rules>"

          --- A list of folders where you have your own SKILL.md
          --- Expected format:
          --- /path/to/dir/<skill_name>/SKILL.md
          ---
          --- Example:
          --- Input Path:
          --- "scratch/custom_rules/"
          ---
          --- Output Rules:
          --- {path = "scratch/custom_rules/vim/SKILL.md", name = "vim"},
          --- ... the other rules in that dir ...
          ---
          custom_rules = {
            vim.fn.expand '~/.claude/skills/',
          },

          --- Configure @file completion (all fields optional, sensible defaults)
          files = {
            -- enabled = true,
            -- max_file_size = 102400,     -- bytes, skip files larger than this
            -- max_files = 5000,            -- cap on total discovered files
            -- exclude = { ".env", ".env.*", "node_modules", ".git", ... },
          },
          --- File Discovery:
          --- - In git repos: Uses `git ls-files` which automatically respects .gitignore
          --- - Non-git repos: Falls back to filesystem scanning with manual excludes
          --- - Both methods apply the configured `exclude` list on top of gitignore

          --- What autocomplete engine to use. Defaults to native (built-in) if not specified.
          source = 'native', -- "native" (default), "cmp", or "blink"
        },

        --- WARNING: if you change cwd then this is likely broken
        --- ill likely fix this in a later change
        ---
        --- md_files is a list of files to look for and auto add based on the location
        --- of the originating request.  That means if you are at /foo/bar/baz.lua
        --- the system will automagically look for:
        --- /foo/bar/AGENT.md
        --- /foo/AGENT.md
        --- assuming that /foo is project root (based on cwd)
        md_files = {
          'AGENTS.md',
          'CLAUDE.md',
          'AGENT.md',
        },
      }

      -- the prompt window submits on :w (BufWriteCmd), so <C-s> just triggers a write
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('99_prompt_submit', { clear = true }),
        pattern = { '99', '99prompt' },
        callback = function(ev)
          if vim.bo[ev.buf].buftype ~= 'acwrite' then
            return
          end
          vim.keymap.set({ 'n', 'i' }, '<C-s>', function()
            vim.cmd.stopinsert()
            vim.cmd.write()
          end, { buffer = ev.buf, nowait = true, desc = '99 submit prompt' })
        end,
      })
    end,
  },
}
