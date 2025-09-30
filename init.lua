local vim = vim

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
vim.opt.splitright = true
vim.opt.splitbelow = true
-- vim.o.t_Co = 256
vim.opt.scrollback = 20000
-- vim.opt.guicursor=""
-- vim.opt.nohlsearch = true
-- vim.opt.hidden = true
-- vim.opt.noerrorbells = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = false
-- vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
-- vim.opt.noswapfile = true
-- vim.opt.nobackup = true
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.scrolloff = 8
-- vim.opt.signcolumn='no'
vim.opt.cmdheight = 1
vim.opt.updatetime = 50
-- vim.opt.shortmess = vim.opt.shortmess .. 'c'
vim.opt.textwidth = 79
vim.opt.cursorline = true
vim.opt.colorcolumn = '80' -- works! (using integer will fail)
vim.opt.completeopt = 'menuone,noselect'
vim.g.netrw_hide = 0
vim.g.netrw_nogx = 1
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20
vim.opt.laststatus = 3
-- }}}
-- [[ Setting options ]] {{{
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- search highlight
vim.opt.hlsearch = false
vim.opt.breakindent = true
vim.wo.number = true

-- vim.opt.foldmethod = 'marker'
-- vim.opt.foldmethod="expr"
-- vim.opt.foldmethod = 'syntax'
-- vim.opt.foldmethod = 'manual'
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.foldcolumn = '1'
vim.o.foldenable = false
-- vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldnestmax = 1
vim.o.foldtext = ''

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Enable mouse mode
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
vim.opt.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true

-- }}}
--
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
-- }}}

-- Diagnostic keymaps {{{
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
-- }}}

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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

  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  { import = 'custom.plugins' },
  { import = 'custom.plugins.runner' },
}, {})

-- [settings] {{{
function UseZsh()
  local handle = io.popen 'which zsh'
  if handle == nil then
    return
  end
  local result = handle:read '*a'
  handle:close()

  if result ~= '' then
    -- Esto elimina los espacios en blanco
    vim.opt.shell = result:match '^%s*(.-)%s*$'
  end
end

-- [[keymaps]] {{{
vim.keymap.set('i', '<C-e>', '<C-o>$', { noremap = true, silent = true, desc = 'Move to end of line in insert mode' })
--
-- [[ fugitive ]] {{{
vim.keymap.set('n', '<leader>w', ':Git<cr>', { noremap = true, desc = 'Open Git status' })
vim.keymap.set('n', '<leader>W', ':tab Git<cr>', { noremap = true, desc = 'Open Git status in a new tab' })
vim.keymap.set('n', '<C-g>', ':GBrowse<cr>', { noremap = true, desc = 'browse current file on github' })
vim.keymap.set('v', '<C-g>', ':GBrowse<cr>', { noremap = true, desc = 'browse current file and line on github' })
vim.keymap.set('n', '<C-G>', ':GBrowse!<cr>', { noremap = true, desc = 'yank github url of the current file' })
vim.keymap.set('v', '<C-G>', ':GBrowse!<cr>', { noremap = true, desc = 'yank github url of the current line' })
-- }}}

-- terminal settings {{{
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { noremap = true, desc = 'Switch to normal mode from terminal' })
vim.keymap.set('t', '<C-w>h', '<C-\\><C-n><C-w>h', { noremap = true, desc = 'Move cursor to the left window' })
vim.keymap.set('t', '<C-w>j', '<C-\\><C-n><C-w>j', { noremap = true, desc = 'Move cursor to the below window' })
vim.keymap.set('t', '<C-w>k', '<C-\\><C-n><C-w>k', { noremap = true, desc = 'Move cursor to the above window' })
vim.keymap.set('t', '<C-w>l', '<C-\\><C-n><C-w>l', { noremap = true, desc = 'Move cursor to the right window' })
vim.keymap.set('t', '<C-w>w', '<C-\\><C-n><C-w>w', { noremap = true, desc = 'Switch to the next window' })
-- vim.keymap.set('t', '<C-P>', '<C-\\><C-n>pi<cr>', { noremap = true })
-- vim.keymap.set('n', '<C-l>', 'i<C-l>', {noremap = true})
-- }}}

-- [[ luasnip:snippets ]] {{{
-- }}}

-- [[ pdbrc ]] {{{
local pdbrc_win
local current_win

function AddPdbrc()
  local file = vim.fn.expand '%:p'
  local line = vim.fn.line '.'
  local cmd = 'b ' .. file .. ':' .. line
  local full_cmd = [[!echo ']] .. cmd .. [[' >> .pdbrc]]
  vim.cmd(full_cmd)
  current_win = vim.api.nvim_get_current_win()
  if not pdbrc_win or not vim.api.nvim_win_is_valid(pdbrc_win) then
    vim.cmd '5split .pdbrc'
    pdbrc_win = vim.api.nvim_get_current_win()
  else
    vim.api.nvim_set_current_win(pdbrc_win)
  end
  vim.cmd 'norm G'
  vim.api.nvim_set_current_win(current_win)
end
-- }}}

vim.keymap.set('n', 'bp', AddPdbrc, { noremap = true, silent = true, desc = 'Add pdbrc' })

-- escape
vim.keymap.set('i', 'kj', '<esc>', { noremap = true, silent = true, desc = 'Exit insert mode with kj' })
vim.keymap.set('i', 'jk', '<esc>', { noremap = true, silent = true, desc = 'Exit insert mode with jk' })

-- This doesn't work as expected
-- vim.keymap.set('t' , 'jk' , '<esc><esc>' , { noremap = true , silent = true, desc = 'Exit terminal mode with jk' })
-- vim.keymap.set('t' , 'kj' , '<esc><esc>' , { noremap = true , silent = true, desc = 'Exit terminal mode with kj' })

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
vim.keymap.set('n', '<leader>-', ':Ex %:h<cr>', { desc = "Open the current file's directory in the file explorer", silent = false })

-- paste / yank / copy
vim.keymap.set('n', '<leader>0', '"0p', { desc = 'Paste from register 0', silent = false })
vim.keymap.set('n', '<leader>9', '"1p', { desc = 'Paste from register 1', silent = false })
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste clipboard register' })
vim.keymap.set('v', '<leader>p', '"+p', { desc = 'Paste clipboard register' })
vim.keymap.set('n', '<leader>y', '"+yy', { noremap = true, desc = 'copy to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, desc = 'copy to system clipboard' })
vim.keymap.set('n', '<leader>yf', ':let @+ = expand("%:p")<cr>', { noremap = true, desc = 'yank filename path' })

-- [reload]
vim.keymap.set('n', '<leader><cr>', ':source ~/.config/nvim/init.lua<cr>', { noremap = true })
vim.keymap.set('n', '<leader>rc', ':vnew ~/.config/nvim/init.lua<cr>', { noremap = true })

-- replace in all file
-- vim.keymap.set('n', '<leader>s', ':s/<C-r><C-w>/<C-r><C-w>/gI<left><left><left>', { noremap = true, desc = 'search and replace word under cursor' })
vim.keymap.set('n', '<leader>s', ':%s/<C-r><C-w>/<C-r><C-w>/gI<left><left><left>', { noremap = true, desc = 'search and replace word under cursor' })
vim.keymap.set('n', '<leader>gw', ":grep '<C-R><C-W>'", { desc = 'Find word using grep command' })

-- [move line]
vim.keymap.set('i', '<C-k>', '<esc>:.m-2 | startinsert<cr>', { noremap = true, desc = 'move line up' })
vim.keymap.set('i', '<C-j>', '<esc>:.m+1 | startinsert<cr>', { noremap = true, desc = 'move line down' })
vim.keymap.set('n', '<leader>k', ':m .-2<cr>==', { noremap = true, desc = 'move line up' })
vim.keymap.set('n', '<leader>j', ':m .+1<cr>==', { noremap = true, desc = 'move line down' })

-- [quickfix]
vim.keymap.set('n', '<leader>on', ':copen<cr>', { noremap = true, desc = 'open quickfix' })
vim.keymap.set('n', '<leader>cn', ':cnext<cr>', { noremap = true, desc = 'next error' })
vim.keymap.set('n', '<leader>cp', ':cprev<cr>', { noremap = true, desc = 'previous error' })

-- }}}

vim.cmd [[
augroup Latex
  au!
  au BufWritePost *.tex silent !dex pdflatex % && firefox %:t:r.pdf
augroup end
]]

-- terraform {{{
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

-- }}}

-- [[ Setting options ]] {{{
if vim.fn.has 'mac' == 1 then
  vim.g.netrw_browsex_viewer = 'open'
else
  -- Set the default viewer for other operating systems
  vim.g.netrw_browsex_viewer = 'xdg-open'
end

-- }}}

-- [[ gist ]] {{{
if vim.fn.has 'mac' == 1 then
  vim.g.gist_clip_command = 'pbcopy'
else
  vim.g.gist_clip_command = 'xclip -selection clipboard'
end
vim.g.gist_detect_filetype = 1
vim.g.gist_open_browser_after_post = 1
vim.g.gist_show_privates = 1
vim.g.gist_user = 'asdf8601'
vim.g.gist_token = os.getenv 'GH_GIST_TOKEN'
-- }}}

-- tag bar
vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }
vim.g.completion_enable_snippet = 'vim-vsnip'

-- vim.keymap.set('n', '<leader>sn', ':\'<,\'>!sort -n -k 2', { noremap = true, desc = 'sort lines numerically' })
-- vim.keymap.set('v', '<leader>s', ':\'<,\'>!sort -f<cr>', { noremap = true, desc = 'sort lines' })
-- vim.keymap.set('v', '<leader>sf', ':!sqlformat  -k upper -r --indent_after_first --indent_columns -<cr>', { noremap = true })
vim.keymap.set('v', '<leader>sf', ':!sqlfmt -<cr>', { noremap = true })

-- [markdown]
vim.keymap.set('n', '<leader>tu', 'yypVr-', { noremap = true, desc = 'underline word under cursor' })
vim.keymap.set('n', '<leader>tx', ':s/\\[\\s\\?\\]/[x]/<cr>', { noremap = true, desc = 'check a box in markdown' })
vim.keymap.set('n', '<leader>t<space>', ':s/\\[x\\]/[ ]/<cr>', { noremap = true, desc = 'uncheck a box in markdown' })
vim.keymap.set('n', '<leader>ta', 'I- [ ] <esc>', { noremap = true, desc = 'append empty checkbox in markdown' })
vim.keymap.set('n', '<leader>m', ':MaximizerToggle<cr>', { noremap = true, desc = 'Maximize current window' })

vim.keymap.set('n', '<leader>/', '/<C-r><C-w>', { desc = '[S]earch [R]esume' })

vim.keymap.set('n', '<leader>zz', '<cmd>ZenMode<cr>', { noremap = true, desc = 'ZenMode toggle' })
vim.keymap.set('v', '<leader>h', ':<c-u>HSHighlight 2<cr>', { noremap = true, desc = 'high-str' })
-- vim.keymap.set("n", "<leader>h", ":<c-u>HSHighlight 2<cr>", {noremap = true, desc = 'high-str'})

-- add python cells {{{
vim.keymap.set('n', '<leader>cO', 'O%%<esc>:norm gcc<cr>j', { noremap = true, desc = 'Insert a cell comment above the current line' })
vim.keymap.set('n', '<leader>co', 'o%%<esc>:norm gcc<cr>k', { noremap = true, desc = 'Insert a cell comment below the current line' })

vim.keymap.set('n', '<leader>c-', 'O<esc>80i-<esc>:norm gcc<cr>j', { noremap = true, desc = 'Insert a horizontal line of dashes above the current line' })
-- vim.keymap.set('n', 'vic', 'V?%%<cr>o/%%<cr>koj', { noremap = true, desc = 'Visually select a cell and insert a comment before and after it' })

-- }}}

-- file operations {{{
vim.keymap.set('n', '<leader>cd', ':lcd %:p:h<cr>', { noremap = true, silent = true, desc = 'Change to the directory of the current file' })
vim.keymap.set('n', '<leader>fn', ":echo expand('%')<cr>", { noremap = true })
-- }}}

-- [[markdown]] {{{
-- vim.g.markdown_fenced_languages = { 'html', 'python', 'bash=sh', 'sql', 'mermaid' }
-- vim.g.markdown_minlines = 50
-- TODO: fill this
-- vim.g.mkdp_markdown_css = ''
vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 0
vim.g.mkdp_page_title = '${name}'
vim.g.mkdp_theme = 'light'
-- }}}

-- Create command to call jq '.' % and replace the buffer with the output {{{
-- vim.api.nvim_command('command! -buffer Jq %!jq "."')
vim.api.nvim_create_user_command('Jq', '%!jq', { nargs = 0 })
-- }}}

-- grep program {{{
if vim.fn.executable 'rg' == 1 then
  vim.o.grepprg = 'rg --hidden --glob "!.git" --glob "!node_modules" --glob "!.venv" --vimgrep'
  vim.o.grepformat = '%f:%l:%c:%m'
else
  vim.print 'ripgrep not found'
end
-- }}}
-- }}}

-- [[ autocomands ]] {{{
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
ASDF8601 = augroup('ASDF8601', { clear = true })

autocmd('BufWritePre', { group = ASDF8601, pattern = '*', command = '%s/\\s\\+$//e' })
autocmd('FileType', { group = ASDF8601, pattern = 'markdown', command = 'setl conceallevel=2 spl=en,es | TSBufDisable highlight' })
autocmd('FileType', { group = ASDF8601, pattern = 'make', command = 'setl noexpandtab shiftwidth=4 softtabstop=0' })
autocmd('TermOpen', { group = ASDF8601, pattern = '*', command = 'setl nonumber norelativenumber' })
autocmd('FileType', { group = ASDF8601, pattern = 'fugitive', command = 'setl nonumber norelativenumber' })
-- autocmd('FileType', { group = ASDF8601, pattern = 'python', command = 'nnoremap <buffer> <F8> :!black -l80 -S %<CR><CR>' })
autocmd('FileType', { group = ASDF8601, pattern = 'python', command = 'nnoremap <buffer> <F8> :!ruff format % && ruff check % --fix<CR><CR>' })
autocmd('FileType', { group = ASDF8601, pattern = 'json*', command = 'setl tw=0' })
autocmd('FileType', { group = ASDF8601, pattern = 'python', command = 'nnoremap <buffer> <F7> :!ruff check -l80 %<CR><CR>' })
autocmd('FileType', { group = ASDF8601, pattern = 'python', command = 'nnoremap <buffer> <F9> :!ruff check -l80 --fix %<CR><CR>' })
autocmd({ 'BufEnter', 'BufRead' }, { group = ASDF8601, pattern = { '.autoenv', '.env' }, command = 'setl ft=bash' })
autocmd({ 'BufEnter', 'BufRead' }, { group = ASDF8601, pattern = 'Jenkinsfile', command = 'setl ft=groovy' })
autocmd({ 'BufEnter', 'BufRead' }, { group = ASDF8601, pattern = '*.astro', command = 'set ft=astro' })
autocmd({ 'BufEnter', 'BufRead' }, { group = ASDF8601, pattern = 'requirements*.txt', command = 'setl ft=requirements' })
autocmd({ 'BufEnter', 'BufRead' }, { group = ASDF8601, pattern = 'compose.*.yml', command = 'setl ft=yaml' })
autocmd({ 'BufEnter', 'BufRead' }, { group = ASDF8601, pattern = 'Dockerfile.*', command = 'setl ft=dokerfile' })
autocmd('FileType', {
  group = ASDF8601,
  pattern = 'qf',
  callback = function()
    vim.keymap.set('n', 'q', ':cclose<cr>', { desc = 'close quickfix', buffer = true })
  end,
})

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

vim.keymap.set('n', '<leader>sq', '<Plug>(DBUI_SaveQuery)', { noremap = true })

autocmd({ 'FileType' }, {
  group = ASDF8601,
  pattern = 'markdown',
  command = 'normal zR',
})

autocmd({ 'FileType' }, {
  group = ASDF8601,
  pattern = 'dbui',
  command = 'setl nonumber norelativenumber',
})

autocmd({ 'BufWritePost' }, {
  group = ASDF8601,
  pattern = '~/.Xresources',
  command = 'silent !xrdb <afile> > /dev/null',
})

-- autocommand for WebDev {{{

-- [[ astro ]] {{{
vim.filetype.add {
  extension = {
    mdx = 'mdx',
  },
}
vim.treesitter.language.register('markdown', 'mdx') -- the mdx filetype will use the markdown parser and queries.
-- }}}

-- [[ JS ]]  {{{
local JS = vim.api.nvim_create_augroup('JS', { clear = true })

autocmd({ 'FileType' }, {
  callback = function()
    vim.cmd [[
      colorscheme onedark
    ]]
  end,
  group = JS,
  pattern = { '*.css', '*.js', '*.json', '*.html', '*.astro' },
})

autocmd({ 'BufWritePost' }, {
  callback = function()
    vim.cmd [[
      silent execute('!npx prettier --write . --plugin=prettier-plugin-astro')
    ]]
  end,
  group = JS,
  pattern = { '*.css', '*.js', '*.json', '*.html', '*.astro' },
})
-- }}}
-- }}}

-- vim: ts=2 sts=2 sw=2 et tw=0
