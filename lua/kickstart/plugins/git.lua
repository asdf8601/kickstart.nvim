return {
  { 'tpope/vim-rhubarb', lazy = true }, -- github extension, loaded by fugitive
  {
    'tpope/vim-fugitive', -- git extension
    dependencies = { 'tpope/vim-rhubarb' },
    cmd = { 'Git', 'G', 'GBrowse', 'Gdiffsplit', 'Gvdiffsplit', 'Ghdiffsplit', 'Gread', 'Gwrite', 'Gwq', 'Gedit', 'Gsplit', 'Gvsplit', 'Gtabedit', 'Gpedit', 'GMove', 'GRename', 'GDelete', 'GRemove', 'GUnlink', 'GcLog', 'GlLog', 'Gclog', 'Gllog', 'Ggrep', 'Glgrep', 'Gcd', 'Glcd', 'Gstatus', 'Gblame' },
  },
  {
    -- git diff view
    'sindrets/diffview.nvim',
    cmd = 'DiffviewOpen',
  },
  { 'lewis6991/gitsigns.nvim' },
}
