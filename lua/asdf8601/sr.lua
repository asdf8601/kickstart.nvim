-- [[ gh sr ]] {{
-- Simple review: edit a PR in a worktree; `gh sr` turns the diff into suggestions.
local function sr(args, on_ok)
  vim.cmd 'silent! wall'
  vim.system(vim.list_extend({ 'gh', 'sr' }, args), { text = true, cwd = vim.fn.getcwd() }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        vim.notify(vim.trim(res.stderr ~= '' and res.stderr or res.stdout), vim.log.levels.ERROR)
        return
      end
      local lines = vim.split(vim.trim(res.stdout), '\n')
      vim.notify(lines[#lines]:find 'https?://' and lines[#lines] or lines[1])
      if on_ok then
        on_ok(lines)
      end
    end)
  end)
end

local actions = {}

function actions.open(args)
  sr({ 'open', args }, function(lines)
    vim.cmd.tabnew()
    vim.cmd.tcd(lines[#lines])
    vim.cmd.edit '.'
  end)
end

function actions.preview()
  sr({ 'review', '--dry-run' }, function(lines)
    local win = vim.fn.bufwinid(lines[2])
    if win ~= -1 then
      vim.api.nvim_set_current_win(win)
      vim.cmd 'checktime'
      return
    end
    vim.cmd('vsplit ' .. vim.fn.fnameescape(lines[2]))
    vim.bo.readonly = true
  end)
end

function actions.review()
  sr { 'review' }
end

function actions.submit(args)
  local event, message = args:match '^(%S*)%s*(.*)$'
  sr { 'submit', event ~= '' and event or 'comment', message }
end

function actions.discard()
  if vim.fn.confirm('Delete pending review and worktree?', '&Yes\n&No', 2) ~= 1 then
    return
  end
  local root = vim.fn.getcwd() .. '/'
  sr({ 'discard' }, function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.startswith(vim.api.nvim_buf_get_name(buf), root) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
    pcall(vim.cmd.tabclose)
  end)
end

-- Mirrors the CLI: open <N|URL>, preview, review (post as pending), submit [event] [msg], discard.
vim.api.nvim_create_user_command('SimpleReview', function(opts)
  local name, args = opts.args:match '^(%S+)%s*(.*)$'
  if not actions[name] then
    vim.notify('SimpleReview open|preview|review|submit|discard', vim.log.levels.ERROR)
    return
  end
  actions[name](args)
end, {
  nargs = '+',
  complete = function(lead, line)
    local words = vim.split(line, '%s+')
    local options = #words <= 2 and vim.tbl_keys(actions)
      or words[2] == 'submit' and #words == 3 and { 'comment', 'approve', 'request-changes' }
      or {}
    return vim.tbl_filter(function(o) return vim.startswith(o, lead) end, options)
  end,
  desc = 'gh sr: review a PR by editing it',
})

-- Insert "REVIEW(3/5+N): text" above the selection; a leading 1-5 sets the importance.
vim.keymap.set({ 'n', 'x' }, '<leader>R', function()
  local first, last = vim.fn.line 'v', vim.fn.line '.'
  if first > last then
    first, last = last, first
  end
  vim.cmd 'normal! \27'
  vim.ui.input({ prompt = 'REVIEW [1-5] text: ' }, function(text)
    if not text or text == '' then
      return
    end
    local score, rest = text:match '^([1-5])%s+(.*)$'
    local label = score and score .. '/5'
    local n = last - first + 1
    local tag = (label or '') .. (n > 1 and '+' .. n or '')
    local review = 'REVIEW' .. (tag ~= '' and '(' .. tag .. ')' or '') .. ': ' .. (rest or text)
    local cs = vim.bo.commentstring ~= '' and vim.bo.commentstring or '# %s'
    local indent = vim.fn.getline(first):match '^%s*'
    vim.api.nvim_buf_set_lines(0, first - 1, first - 1, false, { indent .. cs:gsub('%%s', function() return review end) })
  end)
end, { desc = 'gh sr: add a REVIEW comment over the selection' })

-- }}

return {}
