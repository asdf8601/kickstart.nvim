-- [[ Custom setup ]]
-- [[ Setting options ]] {{
if vim.fn.has('mac') == 1 then
  vim.g.netrw_browsex_viewer = 'open'
else
  -- Set the default viewer for other operating systems
  vim.g.netrw_browsex_viewer = 'xdg-open'
end

vim.o.t_Co = 256
vim.o.scrollback = 20000
-- vim.o.guicursor=""
-- vim.o.nohlsearch = true
-- vim.o.hidden = true
-- vim.o.noerrorbells = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
-- vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
-- vim.o.noswapfile = true
-- vim.o.nobackup = true
vim.o.undodir = os.getenv("HOME") .. '/.vim/undodir'
vim.o.undofile = true
vim.o.incsearch = true
vim.o.scrolloff = 8
-- vim.o.signcolumn='no'
vim.o.cmdheight = 1
vim.o.timeoutlen = 200
vim.o.updatetime = 50
-- vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.textwidth = 79
vim.o.cursorline = true
vim.o.colorcolumn = "80" -- works! (using integer will fail)
vim.o.completeopt = 'menuone,noselect'
vim.g.netrw_hide = 0
vim.o.laststatus = 3
vim.g.netrw_nogx = 1

-- }}

-- [[ gist ]] {{
vim.g.gist_clip_command = 'xclip -selection clipboard'
vim.g.gist_detect_filetype = 1
vim.g.gist_open_browser_after_post = 1
vim.g.gist_show_privates = 1
vim.g.gist_user = "mmngreco"
vim.g.gist_token = os.getenv('GH_GIST_TOKEN')
-- }}


-- [[ Setting keymaps ]] {{

function GetVisual()
  local _, ls, cs = unpack(vim.fn.getpos('v'))
  local _, le, ce = unpack(vim.fn.getpos('.'))
  -- fix corner case when selection is linewise
  -- vim.print({ls=ls, cs=cs, le=le, ce=ce})
  cs = cs == 0 and 1 or cs
  ls = ls == 0 and 1 or ls
  le = le == 0 and 1 or le
  ce = ce == 0 and 1 or ce
  local data = vim.api.nvim_buf_get_text(0, ls-1, cs-1, le-1, ce, {})
  return table.concat(data, '\\n')
end

function OpenUrl()
  local mode = vim.fn.mode()
  local url
  local text

  if mode == 'v' or mode == 'V' then
    text = GetVisual()
  else
    text = vim.fn.expand('<cWORD>')
  end

  -- chek if it is a url
  if text:match('^https?://') then
    url = text
  else
    -- replace spaces with +
    text = text:gsub('\\n', '')
    text = text:gsub('%s+', '+')
    url = 'https://www.google.com/search?q=' .. text
  end
  local cmd = 'firefox ' .. url .. ' &'
  vim.print(cmd)
  vim.fn.system(cmd)

end


vim.keymap.set('n', 'gx', OpenUrl, { noremap = true, silent = true })
vim.keymap.set('v', 'gx', OpenUrl, { noremap = true, silent = true })

-- motion
vim.keymap.set('i', 'kj', '<esc>', { noremap = true, silent = true })
vim.keymap.set('i', 'jk', '<esc>', { noremap = true, silent = true })

-- shebang
vim.keymap.set('n', '<leader>sh', ":0<cr>O#!/usr/bin/env bash<esc><C-o><C-o>", { desc = 'Add shebang' })

-- commands
vim.keymap.set('n', '!<space>', ':.!sh ' , { noremap = true, desc = 'Fill command to execute sh using current line' })
vim.keymap.set('n', '!<cr>', ':.!sh<cr>' , { noremap = true, desc = 'Execute sh current line' })

-- Explore
vim.keymap.set('n', '<leader>-', ':Ex %:h<cr>', { desc = "Open the current file's directory in the file explorer", silent = false })

-- paste / yank / copy
vim.keymap.set('n', '<leader>0', '"0p', { desc = "Paste from register 0", silent = false })
vim.keymap.set('n', '<leader>1', '"1p', { desc = "Paste from register 1", silent = false })
vim.keymap.set("v", "<C-c>", "\"0y", { noremap = true, desc = 'yank to clipboard' })
vim.keymap.set("n", "<C-c>", "\"0yy", { noremap = true, desc = 'yank to clipboard' })
vim.keymap.set('n', '<C-v><C-v>', '"0p', { desc = 'Paste 0 register' })
vim.keymap.set('i', '<C-v>', '<C-r>0', { desc = 'Paste 0 register' })
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste clipboard register' })
vim.keymap.set('v', '<leader>p', '"+p', { desc = 'Paste clipboard register' })
vim.keymap.set('n', '<leader>y', '"+yy', { noremap = true, desc = 'copy to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, desc = 'copy to system clipboard' })
vim.keymap.set('n', '<leader>yf', ':let @+ = expand("%:p")<cr>', { noremap = true, desc = 'yank filename/buffer path' })

-- tag bar
vim.keymap.set('n', '<leader>t', ':SymbolsOutline<cr>', { desc = "Symbols outline", silent = false })

-- reload
vim.keymap.set('n', '<leader><cr>', ':source ~/.config/nvim/init.lua<cr>', { noremap = true })
vim.keymap.set('n', '<leader>rc', ':new ~/.config/nvim/init.lua<cr>', { noremap = true })

-- terminal settings
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true, desc = "Switch to normal mode" })
vim.keymap.set('t', '<C-w>h', '<C-\\><C-n><C-w>h', { noremap = true, desc = "Move cursor to the left window" })
vim.keymap.set('t', '<C-w>j', '<C-\\><C-n><C-w>j', { noremap = true, desc = "Move cursor to the below window" })
vim.keymap.set('t', '<C-w>k', '<C-\\><C-n><C-w>k', { noremap = true, desc = "Move cursor to the above window" })
vim.keymap.set('t', '<C-w>l', '<C-\\><C-n><C-w>l', { noremap = true, desc = "Move cursor to the right window" })
vim.keymap.set('t', '<C-w>w', '<C-\\><C-n><C-w>w', { noremap = true, desc = "Switch to the next window" })
-- vim.keymap.set('t', '<C-P>', '<C-\\><C-n>pi<cr>', { noremap = true })
-- vim.keymap.set('n', '<C-l>', 'i<C-l>', {noremap = true})

vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }
vim.g.completion_enable_snippet = 'vim-vsnip'
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, desc = 'Show Hover' })
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, desc = 'Rename' })
vim.keymap.set('n', '<leader>gd', ':lua vim.lsp.buf.definition()<CR>', { noremap = true, desc = 'Go to Definition' })
vim.keymap.set('n', '<leader>gi', ':lua vim.lsp.buf.implementation()<CR>', { noremap = true, desc = 'Go to Implementation' })
vim.keymap.set('n', '<leader>gh', ':lua vim.lsp.buf.signature_help()<CR>', { noremap = true, desc = 'Show Signature Help' })
vim.keymap.set('n', '<leader>gf', ':lua vim.lsp.buf.references()<CR>', { noremap = true, desc = 'Find References' })
vim.keymap.set('n', '<leader>ga', ':lua vim.lsp.buf.code_action()<CR>', { noremap = true, desc = 'Code Actions' })
vim.keymap.set('n', '<leader>dq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', { noremap = true, desc = 'Diagnostics Quickfix' })
vim.keymap.set('n', '<leader>dn', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true, desc = 'Go to Next Diagnostic' })
vim.keymap.set('n', '<leader>dp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap = true, desc = 'Go to Previous Diagnostic' })

-- replace in all file
vim.keymap.set('n', '<leader>s', ':%s/<C-r><C-w>/<C-r><C-w>/gI<left><left><left>', { noremap = true, desc = 'search and replace word under cursor' })
-- vim.keymap.set('n', 'gs', ':%s//g<left><left>', {noremap = true, desc = 'search and replace' })

vim.keymap.set('i', '<C-J>', '<esc>:.m+1 | startinsert<cr>', { noremap = true, desc = 'move line down' })
vim.keymap.set('i', '<C-K>', '<esc>:.m-2 | startinsert<cr>', { noremap = true, desc = 'move line up' })

vim.keymap.set('n', '<leader>k', ':m .-2<cr>==', { noremap = true, desc = 'move line up' })
vim.keymap.set('n', '<leader>j', ':m .+1<cr>==', { noremap = true, desc = 'move line down' })

vim.keymap.set('n', '<leader>cn', ':cnext<cr>', { noremap = true, desc = 'next error' })
vim.keymap.set('n', '<leader>cp', ':cprev<cr>', { noremap = true, desc = 'previous error' })


-- vim.keymap.set('n', '<leader>sn', ':\'<,\'>!sort -n -k 2', { noremap = true, desc = 'sort lines numerically' })
-- vim.keymap.set('v', '<leader>s', ':\'<,\'>!sort -f<cr>', { noremap = true, desc = 'sort lines' })
vim.keymap.set('v', '<leader>sf', ':!sqlformat  -k upper -r --indent_after_first --indent_columns -<cr>', { noremap = true })

vim.keymap.set('n', '<leader>tu', 'yypvawr-', { noremap = true, desc = 'underline word under cursor' })
vim.keymap.set('n', '<leader>tx', ':s/\\[\\s\\?\\]/[x]/<cr>', { noremap = true, desc = 'check a box in markdown' })
vim.keymap.set('n', '<leader>t<space>', ':s/\\[x\\]/[ ]/<cr>', { noremap = true, desc = 'uncheck a box in markdown' })
vim.keymap.set('n', '<leader>ta', 'I- [ ] <esc>', { noremap = true, desc = 'append empty checkbox in markdown' })
vim.keymap.set('n', '<leader>m', ':MaximizerToggle<cr>', { noremap = true, desc = 'Maximize current window' })

vim.keymap.set('n', '<leader>zz', '<cmd>ZenMode<cr>', { noremap = true, desc = 'ZenMode toggle' })
vim.keymap.set("v", "<leader>h", ":<c-u>HSHighlight 2<cr>", { noremap = true, desc = 'high-str' })
-- vim.keymap.set("n", "<leader>h", ":<c-u>HSHighlight 2<cr>", {noremap = true, desc = 'high-str'})

-- add python cells
vim.keymap.set('n', '<leader>co', 'O%%<esc>:norm gcc<cr>j', { noremap = true, desc = 'Insert a cell comment above the current line' })
vim.keymap.set('n', '<leader>cO', 'o%%<esc>:norm gcc<cr>k', { noremap = true, desc = 'Insert a cell comment below the current line' })
vim.keymap.set('n', '<leader>c-', 'O<esc>77i-<esc>:norm gcc<cr>j', { noremap = true, desc = 'Insert a horizontal line of dashes above the current line' })
vim.keymap.set('n', 'vic', 'V?%%<cr>o/%%<cr>koj', { noremap = true, desc = 'Visually select a cell and insert a comment before and after it' })

-- markdown {{
vim.g.markdown_fenced_languages = { 'html', 'python', 'bash=sh', 'sql', 'mermaid' }
vim.g.markdown_minlines = 50
-- TODO: fill this
-- vim.g.mkdp_markdown_css = ''
vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 0
vim.g.mkdp_page_title = "${name}"
vim.g.mkdp_theme = 'light'
-- }}

-- {{ Create command to call jq '.' % and replace the buffer with the output
-- vim.api.nvim_command('command! -buffer Jq %!jq "."')
vim.api.nvim_create_user_command('Jq', '%!jq', { nargs = 0 })
-- }}

-- {{ grep program
vim.o.grepprg = 'rg --vimgrep'
vim.o.grepformat = '%f:%l:%c:%m'
-- }}
-- }}


-- [[ autocomands ]] {{
local mmngreco = vim.api.nvim_create_augroup('mmngreco', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', { group = mmngreco, pattern = '*', command = '%s/\\s\\+$//e' })
vim.api.nvim_create_autocmd('BufWritePre', { group = mmngreco, pattern = '*.go', command = 'GoFmt' })
vim.api.nvim_create_autocmd('BufEnter', { group = mmngreco, pattern = '*.dbout', command = 'norm zR' })
vim.api.nvim_create_autocmd('FileType', { group = mmngreco, pattern = 'markdown', command = 'setl conceallevel=2 spl=en,es' })
vim.api.nvim_create_autocmd('FileType', { group = mmngreco, pattern = 'make', command = 'setl noexpandtab shiftwidth=4 softtabstop=0' })
vim.api.nvim_create_autocmd('TermOpen', { group = mmngreco, pattern = '*', command = 'setl nonumber norelativenumber' })
vim.api.nvim_create_autocmd('FileType', { group = mmngreco, pattern = 'fugitive', command = 'setl nonumber norelativenumber' })
vim.api.nvim_create_autocmd('FileType', { group = mmngreco, pattern = 'python', command = 'nnoremap <buffer> <F8> :silent !black -l79 -S %<CR><CR>' })
vim.api.nvim_create_autocmd('FileType', { group = mmngreco, pattern = 'python', command = 'nnoremap <buffer> <F7> :silent !ruff -l79 %<CR><CR>' })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, { pattern = 'Jenkinsfile', group = mmngreco, command = 'setl ft=groovy' })

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- local yank_group = augroup('HighlightYank', {})
Mgreco = augroup('mgreco', {})
autocmd({ "BufWritePre" }, {
  group = Mgreco,
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

autocmd({ 'FileType' }, {
  group = Mgreco,
  pattern = "dbui",
  command = "nmap <buffer> <leader>w <Plug>(DBUI_SaveQuery)",
})

autocmd({ 'FileType' }, {
  group = Mgreco,
  pattern = "markdown",
  command = "normal zR",
})

vim.keymap.set('n', '<leader>sq', '<Plug>(DBUI_SaveQuery)', { noremap = true })

autocmd({ 'FileType' }, {
  group = Mgreco,
  pattern = "dbui",
  command = "setl nonumber norelativenumber",
})

autocmd({ 'BufWritePost' }, {
  group = Mgreco,
  pattern = "~/.Xresources",
  command = "silent !xrdb <afile> > /dev/null",
})


-- autocommand to automatically commit and push modifications on init.lua file using lua api
local AutoCommitVimFiles = vim.api.nvim_create_augroup('AutoCommitVimFiles', { clear = true })
autocmd({'WinClosed', 'VimLeavePre'}, {
  callback = function()
    vim.cmd("Git commit -a -m 'Auto commit' | Git push")
  end,
  group = AutoCommitVimFiles,
  pattern = '*/.config/nvim/*',
})
-- }}

-- [[ Peek ]] {{
local peek = require('peek')

vim.api.nvim_create_user_command('PeekOpen', function()
  if not peek.is_open() and vim.bo[vim.api.nvim_get_current_buf()].filetype == 'markdown' then
    vim.fn.system('i3-msg split horizontal')
    peek.open()
  end
end, {})

vim.api.nvim_create_user_command('PeekClose', function()
  if peek.is_open() then
    peek.close()
    vim.fn.system('i3-msg move left')
  end
end, {})
-- }}

return {}
