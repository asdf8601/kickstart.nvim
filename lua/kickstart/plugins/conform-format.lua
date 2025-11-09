return {
  {
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
      },
    },
  },
}
