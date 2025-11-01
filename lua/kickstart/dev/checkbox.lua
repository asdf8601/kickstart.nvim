-- [[ checkbox ]]
-- [ ]
function SummaryCheckboxes()
  local line = vim.fn.line('.')
  -- local line_orig = vim.fn.getline('.')
  local checked = 0
  local total = 0

  -- find the first line of the paragraph
  while line > 1 and vim.fn.getline(line - 1) ~= '' do
    line = line - 1
  end

  while true do
    local line_text = vim.fn.getline(line)
    if line_text:match('^%s*%-%s%[[xX]%]') then
      checked = checked + 1
      total = total + 1
    elseif line_text:match('^%s*%-%s%[.%]') then
      total = total + 1
    else
      break
    end
    line = line + 1
  end

  vim.api.nvim_input("vipo<esc>A (" .. checked .. "/" .. total .. ")<esc>")
  return { checked, total }
end

return {}
