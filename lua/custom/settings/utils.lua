local function Meet()
  vim.cmd.open("https://meet.google.com/new")
  vim.o.relativenumber = false
  vim.o.number = true
end

vim.api.nvim_create_user_command("Meet", Meet, { nargs = 0 })

return {}

