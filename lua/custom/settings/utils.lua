local function Meeting()
  vim.o.relativenumber = false
  vim.o.number = true
end
vim.api.nvim_create_user_command("Meeting", Meeting, { nargs = 0 })

return {}

