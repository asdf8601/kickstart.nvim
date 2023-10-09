-- [[ skiz ]] {{
function Skiz(args)
  local name = args.fargs[1]
  if name ~= nil then
    name = vim.fn.join({"-n", name}, " ")
  else
    name = ""
  end
  local ext = args.fargs[2]
  if ext ~= nil then
    ext = vim.fn.join({"-e", ext}, " ")
  else
    ext = ""
  end
  local cmd = vim.fn.join({'skiz', name, ext}, " ")
  local output = vim.fn.system(cmd)
  vim.cmd('e ' .. output)
end
vim.api.nvim_create_user_command('Skiz', Skiz, { nargs = '*' })
vim.keymap.set('n', '<leader>sk', ':Skiz<cr>', { noremap = true, desc = 'New Skiz' })
-- }}

-- scratch
function CreateScratch()
  local parent = './.scratches'
  if vim.fn.isdirectory(parent) == 0 then
    vim.fn.mkdir(parent, 'p')
  end
  local fpath = vim.fn.input('Enter filename or extension (.py): ') or '.py'
  local fname_ext = vim.split(fpath, '.', { plain = true })
  local fname = fname_ext[1]
  local ext = '.' .. fname_ext[2]

  local file = function(n)
    return vim.fn.expand(parent .. '/' .. n .. ext)
  end

  if fname == '' then
    local num = 0
    while (vim.fn.filereadable(file(num)) == 0) and (num <= 500) do
      num = num + 1
    end
    fname = file(num)
  end

  vim.cmd('10new ' .. fname .. ext)

  -- vim.bo.buftype = '__scratch__'
  -- vim.bo.filetype = 'markdown'
  -- vim.bo.bufhidden = 'wipe'
  -- vim.bo.swapfile = false
  vim.bo.modifiable = true
  vim.bo.textwidth = 0
end
vim.keymap.set('n', '<leader>ss', ':lua CreateScratch()<cr>', { noremap = true, desc = 'create scratch buffer' })
return {}
