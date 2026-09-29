-- Go is handled here by gopls instead of conform: goimports costs ~2s whenever its module
-- index goes cold, while gopls already holds the module in memory and answers in ~100ms.
-- One autocmd owns both halves, imports and formatting, so Go never straddles two mechanisms.
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  group = vim.api.nvim_create_augroup('go_format_on_save', { clear = true }),
  callback = function(args)
    local clients = vim.lsp.get_clients { bufnr = args.buf, name = 'gopls' }
    if #clients == 0 then
      vim.notify('gopls not attached: saved without formatting', vim.log.levels.WARN)
      return
    end
    local enc = clients[1].offset_encoding or 'utf-16'

    local params = vim.lsp.util.make_range_params(0, enc)
    params.context = { only = { 'source.organizeImports' }, diagnostics = {} }
    local res = vim.lsp.buf_request_sync(args.buf, 'textDocument/codeAction', params, 2000)
    for _, client_res in pairs(res or {}) do
      for _, action in pairs(client_res.result or {}) do
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, enc)
        end
      end
    end

    vim.lsp.buf.format { bufnr = args.buf, async = false, timeout_ms = 2000 }
  end,
})

return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
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
      format_on_save = function(bufnr)
        -- go is owned by the gopls autocmd at the top of this file
        if vim.bo[bufnr].filetype == 'go' then
          return nil
        end
        return { lsp_format = 'fallback', timeout_ms = 500 }
      end,
    },
  },
}
