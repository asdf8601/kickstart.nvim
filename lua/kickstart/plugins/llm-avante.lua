return {
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
          model = 'claude-sonnet-4.5',
          extra_request_body = {
            temperature = 0,
            max_tokens = 81920,
          },
        },
        gemini = {
          -- model = "gemini-2.0-flash"
          -- model = "gemini-2.5-flash-lite-preview-06-17",
          -- model = 'gemini-2.5-flash',
          model = 'gemini-3-flash-preview',
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
