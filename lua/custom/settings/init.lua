-- [[ Custom setup ]]
-- [[ Setting options ]] {{
if vim.fn.has('mac') == 1 then
  vim.g.netrw_browsex_viewer = 'open'
else
  -- Set the default viewer for other operating systems
  vim.g.netrw_browsex_viewer = 'xdg-open'
end

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

-- tag bar
vim.keymap.set('n', '<leader>t', ':Lspsaga outline<cr>', { desc = "Symbols outline", silent = false })

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
-- vim.api.nvim_create_autocmd('BufEnter', { group = mmngreco, pattern = '*.dbout', command = 'norm zR' })
vim.api.nvim_create_autocmd('FileType', { group = mmngreco, pattern = 'markdown', command = 'setl conceallevel=2 spl=en,es' })
vim.api.nvim_create_autocmd('FileType', { group = mmngreco, pattern = 'make', command = 'setl noexpandtab shiftwidth=4 softtabstop=0' })
vim.api.nvim_create_autocmd('TermOpen', { group = mmngreco, pattern = '*', command = 'setl nonumber norelativenumber' })
vim.api.nvim_create_autocmd('FileType', { group = mmngreco, pattern = 'fugitive', command = 'setl nonumber norelativenumber' })
vim.api.nvim_create_autocmd('FileType', { group = mmngreco, pattern = 'python', command = 'nnoremap <buffer> <F8> :!black -l79 -S %<CR><CR>' })
vim.api.nvim_create_autocmd('FileType', { group = mmngreco, pattern = 'python', command = 'nnoremap <buffer> <F7> :!ruff -l79 %<CR><CR>' })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufRead' }, { pattern = 'Jenkinsfile', group = mmngreco, command = 'setl ft=groovy' })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufRead' }, { pattern = '*.astro', group = mmngreco, command = 'set ft=astro' })

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

-- -- [[ Peek ]] {{
-- local peek = require('peek')
--
-- vim.api.nvim_create_user_command('PeekOpen', function()
--   if not peek.is_open() and vim.bo[vim.api.nvim_get_current_buf()].filetype == 'markdown' then
--     vim.fn.system('i3-msg split horizontal')
--     peek.open()
--   end
-- end, {})
--
-- vim.api.nvim_create_user_command('PeekClose', function()
--   if peek.is_open() then
--     peek.close()
--     vim.fn.system('i3-msg move left')
--   end
-- end, {})
-- -- }}

-- [[ neovim-remote ]] {{
if vim.fn.has('nvim') then
  vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'
end
-- }}

return {}
