function GetVisual(mode)
  local data
  local _, ls, cs = unpack(vim.fn.getpos('v'))
  local _, le, ce = unpack(vim.fn.getpos('.'))
  if mode == 'V' then
      data = vim.api.nvim_buf_get_lines(0, ls-1, le-1, false)
  else
      data = vim.api.nvim_buf_get_text(0, ls-1, cs-1, le-1, ce, {})
  end
  return table.concat(data, '\\n')
end

vim.g.openurl_command = 'open'

function OpenUrl()
  local mode = vim.fn.mode()
  local url
  local text
  local cmd
  local out

  -- get the text to search
  if mode == 'v' or mode == 'V' then
    text = GetVisual(mode)
  else
    text = vim.fn.expand('<cWORD>')
  end

  -- chek if it is a url
  if text:match('https?://') then
    url = string.match(text, 'https?://[%w-_%.%?%.:/%+=&]+[^ >"\',;`]*')
  else
    -- replace spaces with +
    text = text:gsub('\\n', ''):gsub('%s+', '+')
    url = 'https://www.google.com/search?q=' .. text
  end
  cmd = vim.g.openurl_command .. ' "' .. url .. '" &'
  out = vim.fn.system(cmd)
  return out
end


vim.keymap.set('n', 'gx', OpenUrl, { noremap = true, silent = true })
vim.keymap.set('v', 'gx', OpenUrl, { noremap = true, silent = false })

return {}
