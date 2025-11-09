local function abbreviate(name)
  local s = name:gsub('[-_]', ' ')
  s = s:gsub('(%l)(%u)', '%1 %2')

  local parts = {}
  for word in s:gmatch '%S+' do
    parts[#parts + 1] = word
  end
  local letters = {}
  for _, w in ipairs(parts) do
    letters[#letters + 1] = w:sub(1, 2):lower()
  end
  return table.concat(letters, '.')
end

local function shorten_branch(branch)
  if branch:len() < 15 then
    return branch
  end

  local prefix, rest = branch:match '^([^/]+)/(.+)$'
  if prefix then
    return prefix .. '/' .. abbreviate(rest)
  end

  return abbreviate(branch)
end

return {
  {
    -- statusline
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = function()
      require('lualine').setup {
        lualine_b = {
          { 'branch', fmt = shorten_branch },
        },
        options = {
          -- theme = 'auto',
          theme = 'modus-vivendi',
          -- theme = '16color',
          globalstatus = true,
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
        },
      }
    end,
  }
}
