return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      formatters_by_ft = {
        bash = { 'shfmt' },
        css = { 'prettier' },
        docker = { 'dockerfmt' },
        go = { 'gofumpt', 'goimports' },
        html = { 'prettier' },
        javascript = { 'prettier' },
        json = { 'prettier' },
        lua = { 'stylua' },
        python = { 'ruff_fix', 'ruff_format', 'docformatter' },
        sh = { 'shfmt' },
        sql = { 'sqlfmt' },
        yaml = { 'prettier' },
        -- markdown = { { 'prettierd', 'prettier', stop_after_first = true } },
        -- ['*'] = { 'codespell' }, -- apply to all
        -- ['_'] = { 'trim_whitespace' }, -- for the rest
      },
      -- formatters = {
      --   autoimport_fix = {
      --     command = 'autoimport',
      --     args = { '$FILENAME' },
      --     stdin = false,
      --     condition = function(_, ctx)
      --       return vim.fn.executable 'autoimport' == 1 and ctx.filename:match '%.py$'
      --     end,
      --     exit_codes = { 0 },
      --   },
      -- },
    },
  },
}
