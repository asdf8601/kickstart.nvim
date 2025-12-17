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
      formatters_by_ft = {
        bash = { 'shfmt' },
        css = { 'prettier' },
        docker = { 'dockerfmt' },
        go = { 'goimports', 'gofmt', 'gofumpt' },
        html = { 'prettier' },
        javascript = { 'prettier' },
        json = { 'prettier' },
        lua = { 'stylua' },
        python = { 'ruff_fix', 'ruff_format', 'docformatter' },
        sh = { 'shfmt' },
        sql = { 'sqlfmt', args = { '--use-spaces', '--indent-width', '2', '--line-length', '80' } },
        -- yaml = { 'prettier', args = { '--tab-width', '2' } },
        yaml = { 'yamlfmt' },
      },
      default_format_opts = {
        lsp_format = 'fallback',
      },
      notify_on_error = true,
      format_on_save = {
        -- I recommend these options. See :help conform.format for details.
        lsp_format = 'fallback',
        timeout_ms = 500,
      },
    },
  },
}
