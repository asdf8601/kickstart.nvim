-- toggle numbers
vim.g.number = 1

function ToggleNumbers()
  if vim.g.number == 1 then
    vim.g.number = 0
    vim.o.number = false
    vim.o.relativenumber = false
    vim.o.signcolumn = 'no'
  else
    vim.g.number = 1
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.signcolumn = 'yes'
  end
end
vim.api.nvim_create_user_command('ToggleNumbers', ToggleNumbers, {})

-- bucket
function GetVisual(mode)
  local data
  local _, ls, cs = unpack(vim.fn.getpos 'v')
  local _, le, ce = unpack(vim.fn.getpos '.')
  if mode == 'V' then
    data = vim.api.nvim_buf_get_lines(0, ls - 1, le - 1, false)
  else
    data = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
  end
  return table.concat(data, '\\n')
end

local function GsutilImport()
  local bucket = ''
  local mode = vim.fn.mode()

  if mode == 'v' or mode == 'V' then
    bucket = GetVisual(mode)
  else
    bucket = vim.fn.expand '<cWORD>'
  end

  -- remove spaces, qoutes and new lines
  bucket = bucket:gsub('\\n', ''):gsub('%s+', ''):gsub('"', ''):gsub("'", '')

  if not string.match(bucket, 'gs://') then
    vim.print 'Not a valid bucket'
    return
  end

  local tmpfile = '/tmp/' .. string.match(bucket, '[^gs://].*$')
  local cmd = string.format('gsutil -m cp -r %s %s', bucket, tmpfile)
  vim.print(cmd)
  local out = vim.fn.system(cmd)
  vim.print(out)
  vim.cmd.edit(tmpfile)
end

vim.api.nvim_create_user_command('GsutilImport', GsutilImport, { nargs = 0 })
vim.api.nvim_set_keymap('n', '<leader>gg', ':GsutilImport<cr>', { noremap = true, silent = false })

-- Wrap the selected lines in `# fmt: off` / `# fmt: on`, indented like the first line
local function FmtOff(opts)
  local first = vim.fn.getline(opts.line1)
  local indent = first:match '^%s*'
  vim.api.nvim_buf_set_lines(0, opts.line2, opts.line2, false, { indent .. '# fmt: on' })
  vim.api.nvim_buf_set_lines(0, opts.line1 - 1, opts.line1 - 1, false, { indent .. '# fmt: off' })
end

vim.api.nvim_create_user_command('FmtOff', FmtOff, { range = true })
vim.keymap.set('x', '<leader>fo', ':FmtOff<cr>', { desc = 'Wrap selection in [F]mt [O]ff' })
