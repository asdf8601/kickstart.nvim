local M = {}

-- `:Lazy reload` reuses the spec lazy resolved at startup, so edits to a plugin's
-- opts are ignored. Re-parse the spec from disk, drop the plugin's stale autocmds
-- and buffer-local maps, then reload it.
function M.reload(name)
  require('lazy.core.plugin').load()

  local plugin = require('lazy.core.config').plugins[name]
  if not plugin then
    return vim.notify('LazyReload: unknown plugin ' .. name, vim.log.levels.ERROR)
  end

  -- autocmds registered without a group survive the reload and shadow the new ones
  for _, au in ipairs(vim.api.nvim_get_autocmds({})) do
    if type(au.callback) == 'function' then
      local ok, info = pcall(debug.getinfo, au.callback, 'S')
      if ok and info.source and info.source:sub(2):find(plugin.dir, 1, true) then
        pcall(vim.api.nvim_del_autocmd, au.id)
      end
    end
  end

  -- buffer-local maps are applied once per buffer and never refreshed
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      for _, mode in ipairs({ 'i', 'n', 'v', 's' }) do
        for _, m in ipairs(vim.api.nvim_buf_get_keymap(buf, mode)) do
          if m.desc and m.desc:find(name, 1, true) then
            pcall(vim.api.nvim_buf_del_keymap, buf, mode, m.lhs)
          end
        end
      end
    end
  end

  require('lazy.core.loader').reload(plugin)
  vim.notify('LazyReload: ' .. name)
end

vim.api.nvim_create_user_command('LazyReload', function(a) M.reload(a.args) end, {
  nargs = 1,
  desc = 'Reload a lazy.nvim plugin, re-reading its spec from disk',
  complete = function(arg)
    return vim.tbl_filter(
      function(name) return name:find(arg, 1, true) end,
      vim.tbl_keys(require('lazy.core.config').plugins)
    )
  end,
})

return M
