-- Set to true if you have a Nerd Font installed and selected in the terminal
-- table.insert(vim._so_trails, '/?.dylib')
vim.g.have_nerd_font = true

vim.opt.exrc = true
vim.opt.secure = true

vim.opt.winbar = '%=%m %f'
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrollback = 20000
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = false
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.cmdheight = 1
vim.opt.updatetime = 50
vim.opt.textwidth = 79
vim.opt.cursorline = true
vim.opt.colorcolumn = '80' -- works! (using integer will fail)
vim.opt.completeopt = 'menuone,noselect'
vim.g.netrw_hide = 0
vim.g.netrw_nogx = 1
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20
vim.opt.laststatus = 3
-- vim.opt.signcolumn='no'
-- vim.opt.shortmess = vim.opt.shortmess, 'scA'

-- -- tag bar
-- vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }

-- [[ Setting options ]] {{{
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- search highlight
vim.opt.hlsearch = false
vim.opt.breakindent = true
vim.wo.number = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.foldcolumn = '1'
vim.o.foldenable = false
vim.o.foldlevelstart = 99
vim.o.foldtext = ''

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

vim.o.confirm = false
vim.opt.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menu,menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Setting options ]] {{{
if vim.fn.has 'mac' == 1 then
  vim.g.netrw_browsex_viewer = 'open'
else
  -- Set the default viewer for other operating systems
  vim.g.netrw_browsex_viewer = 'xdg-open'
end

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
  { import = 'kickstart.plugins' },
}, {})

require('asdf8601.rush')

-- vim.cmd.colorscheme 'modus-vivendi'
vim.cmd.colorscheme 'modus_vivendi'

-- [settings]
-- [[keymaps]]
vim.keymap.set('i', '<C-e>', '<C-o>$', { noremap = true, silent = true, desc = 'Move to end of line in insert mode' })
--
-- [[ fugitive ]]
vim.keymap.set('n', '<leader>w', ':Git<cr>', { noremap = true, desc = 'Open Git status' })
vim.keymap.set('n', '<leader>W', ':tab Git<cr>', { noremap = true, desc = 'Open Git status in a new tab' })
vim.keymap.set('n', '<C-g>', ':GBrowse<cr>', { noremap = true, desc = 'browse current file on github' })
vim.keymap.set('v', '<C-g>', ':GBrowse<cr>', { noremap = true, desc = 'browse current file and line on github' })
vim.keymap.set('n', '<C-G>', ':GBrowse!<cr>', { noremap = true, desc = 'yank github url of the current file' })
vim.keymap.set('v', '<C-G>', ':GBrowse!<cr>', { noremap = true, desc = 'yank github url of the current line' })

-- terminal settings
vim.keymap.set('t', '<esc><esc>', '<C-\\><C-n>', { noremap = true, desc = 'Switch to normal mode from terminal' })
vim.keymap.set('t', '<C-w>h', '<C-\\><C-n><C-w>h', { noremap = true, desc = 'Move cursor to the left window' })
vim.keymap.set('t', '<C-w>j', '<C-\\><C-n><C-w>j', { noremap = true, desc = 'Move cursor to the below window' })
vim.keymap.set('t', '<C-w>k', '<C-\\><C-n><C-w>k', { noremap = true, desc = 'Move cursor to the above window' })
vim.keymap.set('t', '<C-w>l', '<C-\\><C-n><C-w>l', { noremap = true, desc = 'Move cursor to the right window' })
vim.keymap.set('t', '<C-w>w', '<C-\\><C-n><C-w>w', { noremap = true, desc = 'Switch to the next window' })

-- escape
vim.keymap.set('i', 'kj', '<esc>', { noremap = true, silent = true, desc = 'Exit insert mode with kj' })
vim.keymap.set('i', 'jk', '<esc>', { noremap = true, silent = true, desc = 'Exit insert mode with jk' })

-- [shebang]
vim.keymap.set('n', '<leader>sh', ":mark m<cr>:0<cr>O#!/usr/bin/env bash<esc>'m:delm m<cr>", { desc = 'Add shebang line' })

-- [commands]
vim.keymap.set('n', '<leader>xl', ':!<C-R><C-L>', { noremap = true, desc = 'Fill command with current line' })
vim.keymap.set('n', '<leader>xc', ':.!sh ', { noremap = true, desc = 'Fill command to execute current line in shell' })
vim.keymap.set('n', '<leader>xr', ':.!sh<cr>', { noremap = true, desc = 'E[X]ecute line in shell and [R]eplace with output' })
vim.keymap.set('v', '<leader>xr', ':!sh<cr>', { noremap = true, desc = 'E[X]ecute selection in shell and [R]eplace with output' })
vim.keymap.set('n', '<leader>xs', ':.w !sh<cr>', { noremap = true, desc = 'E[X]ecute line in shell and [S]how output' })
vim.keymap.set('v', '<leader>xs', ':w !sh<cr>', { noremap = true, desc = 'E[X]ecute selection in shell and [S]how output' })

-- Explore
-- vim.keymap.set('n', '-', ':Ex<cr>', { desc = "Open the current file's directory in the file explorer", silent = false })
-- vim.keymap.set('n', '<leader>-', ':Ex %:h<cr>', { desc = "Open the current file's directory in the file explorer", silent = false })

-- paste / yank / copy
vim.keymap.set('n', '<leader>0', '"0p', { desc = 'Paste from register 0', silent = false })
vim.keymap.set('n', '<leader>1', '"1p', { desc = 'Paste from register 1', silent = false })
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste clipboard register' })
vim.keymap.set('v', '<leader>p', '"+p', { desc = 'Paste clipboard register' })
vim.keymap.set('n', '<leader>y', '"+yy', { noremap = true, desc = 'copy to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, desc = 'copy to system clipboard' })
vim.keymap.set('n', '<leader>yf', ':let @+ = expand("%:p")<cr>:echo expand("%:p").."copied"<cr>', { noremap = true, desc = 'yank filename path' })

-- [reload]
vim.keymap.set('n', '<leader><cr>', ':source ~/.config/nvim/init.lua<cr>', { noremap = true })

-- replace in all file
vim.keymap.set('n', '<leader>s', ':%s/<C-r><C-w>/<C-r><C-w>/gI<left><left><left>', { noremap = true, desc = 'search and replace word under cursor' })
vim.keymap.set('n', '<leader>gw', ":grep '<C-R><C-W>'", { desc = 'Find word using grep command' })

-- [move line]
vim.keymap.set('i', '<C-j>', '<esc>:.m+1<cr>==gi', { noremap = true, desc = 'move line down' })
vim.keymap.set('i', '<C-k>', '<esc>:m .-2<cr>==gi', { noremap = true, desc = 'move line up' })
vim.keymap.set('n', '<leader>k', ':m .-2<cr>==', { noremap = true, desc = 'move line up' })
vim.keymap.set('n', '<leader>j', ':m .+1<cr>==', { noremap = true, desc = 'move line down' })

-- [quickfix]
-- vim.keymap.set('n', '<leader>on', ':copen<cr>', { noremap = true, desc = 'open quickfix' })
vim.keymap.set('n', '<leader>cn', ':cnext<cr>', { noremap = true, desc = 'next error' })
vim.keymap.set('n', '<leader>cp', ':cprev<cr>', { noremap = true, desc = 'previous error' })

vim.cmd [[
augroup Latex
  au!
  au BufWritePost *.tex silent !dex pdflatex % && firefox %:t:r.pdf
augroup end
]]

-- terraform
-- https://www.mukeshsharma.dev/2022/02/08/neovim-workflow-for-terraform.html
vim.cmd [[
augroup terraform
  autocmd!
  silent! autocmd! filetypedetect BufRead,BufNewFile *.tf
  autocmd BufRead,BufNewFile *.hcl set filetype=hcl
  autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl
  autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform
  autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json
augroup end
]]

-- if macos then
if vim.fn.has 'mac' == 1 then
  vim.cmd [[
    augroup macos
      autocmd!
      autocmd BufWritePost yabairc !yabai --restart-service
      autocmd BufWritePost skhdrc !skhd --restart-service
    augroup END
  ]]
end

-- file operations
vim.keymap.set('n', '<leader>cd', ':lcd %:p:h<cr>', { noremap = true, silent = true, desc = 'Change to the directory of the current file' })
vim.keymap.set('n', '<leader>fn', ":echo expand('%')<cr>", { noremap = true })

-- Create command to call jq '.' % and replace the buffer with the output
vim.api.nvim_create_user_command('Jq', '%!jq', { nargs = 0 })

-- grep program
if vim.fn.executable 'rg' == 1 then
  vim.o.grepprg = 'rg --hidden --glob "!.git" --glob "!node_modules" --glob "!.venv" --vimgrep'
  vim.o.grepformat = '%f:%l:%c:%m'
else
  vim.print 'ripgrep not found'
end

-- [[ autocomands ]]
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
ASDF8601 = augroup('ASDF8601', { clear = true })

-- autocmd('FileType', { group = ASDF8601, pattern = 'markdown', command = 'setl conceallevel=2 spl=en,es | TSBufDisable highlight' })
-- autocmd('FileType', { group = ASDF8601, pattern = 'python', command = 'nnoremap <buffer> <F8> :!black -l80 -S %<CR><CR>' })

autocmd('BufWritePre', { group = ASDF8601, pattern = '*', command = '%s/\\s\\+$//e' })
autocmd('TermOpen', { group = ASDF8601, pattern = '*', command = 'setl nonumber norelativenumber' })

autocmd('FileType', { group = ASDF8601, pattern = 'fugitive', command = 'setl nonumber norelativenumber' })
autocmd('FileType', { group = ASDF8601, pattern = 'json*', command = 'setl tw=0' })
autocmd('FileType', { group = ASDF8601, pattern = 'make', command = 'setl noexpandtab shiftwidth=4 softtabstop=0' })
autocmd('FileType', {
  group = ASDF8601,
  pattern = 'qf',
  callback = function()
    vim.keymap.set('n', 'q', ':cclose<cr>', { desc = 'close quickfix', buffer = true })
  end,
})

autocmd({ 'BufEnter', 'BufRead' }, { group = ASDF8601, pattern = '*.astro', command = 'set ft=astro' })
autocmd({ 'BufEnter', 'BufRead' }, { group = ASDF8601, pattern = 'Dockerfile.*', command = 'setl ft=dokerfile' })
autocmd({ 'BufEnter', 'BufRead' }, { group = ASDF8601, pattern = 'Jenkinsfile', command = 'setl ft=groovy' })
autocmd({ 'BufEnter', 'BufRead' }, { group = ASDF8601, pattern = 'compose.*.yml', command = 'setl ft=yaml' })
autocmd({ 'BufEnter', 'BufRead' }, { group = ASDF8601, pattern = 'requirements*.txt', command = 'setl ft=requirements' })
autocmd({ 'BufEnter', 'BufRead' }, { group = ASDF8601, pattern = { '.autoenv', '.env' }, command = 'setl ft=bash syntax=bash' })

-- local yank_group = augroup('HighlightYank', {})
autocmd({ 'BufWritePre' }, {
  group = ASDF8601,
  pattern = '*',
  command = '%s/\\s\\+$//e',
})

autocmd({ 'FileType' }, {
  group = ASDF8601,
  pattern = 'dbui',
  command = 'nmap <buffer> <leader>w <Plug>(DBUI_SaveQuery)',
})
autocmd({ 'FileType' }, {
  group = ASDF8601,
  pattern = 'dbui',
  command = 'setl nonumber norelativenumber',
})

vim.keymap.set('n', '<leader>sq', '<Plug>(DBUI_SaveQuery)', { noremap = true })

autocmd({ 'BufWritePost' }, {
  group = ASDF8601,
  pattern = '~/.Xresources',
  command = 'silent !xrdb <afile> > /dev/null',
})

-- [[ astro ]]
-- autocommand for WebDev
vim.filetype.add { extension = { mdx = 'mdx' } }
vim.treesitter.language.register('markdown', 'mdx') -- the mdx filetype will use the markdown parser and queries.

-- vim: ts=2 sts=2 sw=2 et tw=0
