local function Meet()
  vim.cmd.open("https://meet.google.com/new")
  vim.o.relativenumber = false
  vim.o.number = true
end

vim.api.nvim_create_user_command("Meet", Meet, { nargs = 0 })

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

local function GsutilImport()
  local bucket = ""
  local mode = vim.fn.mode()

  if mode == 'v' or mode == 'V' then
    bucket = GetVisual(mode)
  else
    bucket = vim.fn.expand('<cWORD>')
  end

  -- remove spaces, qoutes and new lines
  bucket = bucket:gsub('\\n', ''):gsub('%s+', ''):gsub('"', ''):gsub("'", '')

  if not string.match(bucket, "gs://") then
    vim.print("Not a valid bucket")
    return
  end

  local tmpfile = "/tmp/" .. string.match(bucket, "[^gs://].*$")
  local cmd = string.format("gsutil -m cp -r %s %s", bucket, tmpfile)
  vim.print(cmd)
  local out = vim.fn.system(cmd)
  vim.print(out)
  vim.cmd.edit(tmpfile)
end

vim.api.nvim_create_user_command("GsutilImport", GsutilImport, { nargs = 0 })
vim.api.nvim_set_keymap("n", "<leader>gg", ":GsutilImport<cr>", { noremap = true, silent = false })

-- Examples
-- ========
-- "gs://hola/mundo/que/tal/estas.txt"
-- 'gs://hola/mundo/que/tal/estas.txt'
-- gs://hola/mundo/que/tal/

return {}

