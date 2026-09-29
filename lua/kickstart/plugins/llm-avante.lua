return {
  {
    -- chatgpt like plugin
    'yetone/avante.nvim',
    cmd = {
      'AvanteAsk',
      'AvanteChat',
      'AvanteChatNew',
      'AvanteToggle',
      'AvanteBuild',
      'AvanteRefresh',
      'AvanteFocus',
      'AvanteSwitchProvider',
      'AvanteClear',
      'AvanteShowRepoMap',
      'AvanteModels',
      'AvanteACPModels',
      'AvanteACPModes',
      'AvanteHistory',
      'AvanteStop',
    },
    -- same lhs and modes avante sets itself; the <Plug> rhs exists once it loads
    -- stylua: ignore start
    keys = {
      { '<leader>aa', '<Plug>(AvanteAsk)', mode = { 'n', 'v' }, desc = 'avante: ask' },
      { '<leader>an', '<Plug>(AvanteAskNew)', mode = { 'n', 'v' }, desc = 'avante: create new ask' },
      { '<leader>az', '<Plug>(AvanteZenMode)', mode = { 'n', 'v' }, desc = 'avante: toggle zen mode' },
      { '<leader>ae', '<Plug>(AvanteEdit)', mode = 'v', desc = 'avante: edit' },
      { '<leader>aS', '<Plug>(AvanteStop)', desc = 'avante: stop' },
      { '<leader>ar', '<Plug>(AvanteRefresh)', desc = 'avante: refresh' },
      { '<leader>af', '<Plug>(AvanteFocus)', desc = 'avante: focus' },
      { '<leader>at', '<Plug>(AvanteToggle)', desc = 'avante: toggle' },
      { '<leader>ad', '<Plug>(AvanteToggleDebug)', desc = 'avante: toggle debug' },
      { '<leader>aC', '<Plug>(AvanteToggleSelection)', desc = 'avante: toggle selection' },
      { '<leader>as', '<Plug>(AvanteToggleSuggestion)', desc = 'avante: toggle suggestion' },
      { '<leader>aR', '<Plug>(AvanteShowRepoMap)', desc = 'avante: display repo map' },
      { '<leader>a?', '<Plug>(AvanteSelectModel)', desc = 'avante: select model' },
      { '<leader>ah', '<Plug>(AvanteSelectHistory)', desc = 'avante: select history' },
      { '<leader>aM', '<Plug>(AvanteSelectACPModel)', desc = 'avante: select ACP model' },
      { '<leader>am', '<Plug>(AvanteSelectACPMode)', desc = 'avante: select ACP mode' },
      { '<leader>aB', '<Plug>(AvanteAddAllBuffers)', desc = 'avante: add all open buffers' },
    },
    -- stylua: ignore end
    version = false, -- set this if you want to always pull the latest change
    -- acp_providers = {
    --   ['opencode'] = {
    --     command = 'opencode',
    --     args = { 'acp' },
    --   },
    -- },
    opts = {
      provider = 'gemini',
      providers = {
        -- claude = {
        --   endpoint = 'https://api.anthropic.com',
        --   auth_type = 'max', -- Use Claude Max subscription via OAuth, otherwise use 'api'
        --   model = 'claude-sonnet-4.6',
        --   extra_request_body = {
        --     temperature = 0,
        --     max_tokens = 81920,
        --   },
        -- },
        gemini = {
          -- model = "gemini-2.0-flash"
          -- model = "gemini-2.5-flash-lite-preview-06-17",
          -- model = 'gemini-2.5-flash',
          model = 'gemini-3.8-flash-preview',
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
