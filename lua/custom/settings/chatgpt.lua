
-- chatgpt custom function
function Gpt_command(args)
  -- vim.print(args)
  local mod = args.fargs[1]
  local prompt = ""
  for key, value in ipairs(args.fargs) do
    if key > 1 then
      prompt = prompt .. value .. " "
    end
  end
  local filetype = vim.bo.filetype
  local prefix = 'You are a ' .. filetype .. ' developer/writer expert. '
  prefix = prefix .. 'Avoid comments and explanations unless I ask for it. '
  prefix = prefix .. 'You should make changes using the same language as the input.'

  local cmd = ''
  if prompt == nil then
    prompt = ''
  end
  local _cmd = ''
  local _gpt = 'sgpt --no-md --model "gpt-4o"'

  if mod == '%' then
    _cmd = '%!'.._gpt..' "'
  elseif mod == '.' then
    _cmd = '.!'.._gpt..' "'
  else
    -- NOTE:
    -- if we are here then mod is not a mod but part of the prompt
    prompt = mod .. " " .. prompt
    if args.line1 ~= nil then
        _cmd = '\'<,\'>!'.._gpt..' "'
    else
        _cmd = '!'.._gpt..' "'
    end
  end

  cmd = _cmd .. prefix .. prompt .. '"'
  vim.cmd(cmd)
end

vim.api.nvim_create_user_command('Gpt', Gpt_command, { nargs = "*", range = true })

-- vim.api.nvim_set_keymap('n', '<C-c>f', ':%!chatgpt -p "Avoid comments and explanaitions unless I ask for it. "<left>', { noremap = true, desc = '%!chatgpt' })
-- vim.api.nvim_set_keymap('n', '<C-c>.', ':.!chatgpt -p "Avoid comments and explanaitions unless I ask for it. "<left>', { noremap = true, desc = '.!chatgpt' })
-- vim.api.nvim_set_keymap('v', '<C-c>.', ':!chatgpt -p "Avoid comments and explanaitions unless I ask for it. "<left>', { noremap = true, desc = '!chatgpt' })

return {}
