local ensure_installed = {
  'astro', -- astro
  'tsx', -- astro
  'c',
  'cpp',
  'go',
  'python',
  'lua',
  'rust',
  'javascript',
  'typescript',
  'vimdoc',
  'vim',
  'bash',
  'http',
  'html',
  'css',
  'csv',
  'json',
  'yaml',
  'markdown',
  'markdown_inline',
  'toml',
  -- 'groovy',
  'terraform',
}

return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    -- NOTE: this causes error:
    -- config = function()
    --   require 'config.treesitter-textobjects'
    -- end,
  },
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    -- NOTE: this causes error:
    -- main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
      ensure_installed = ensure_installed,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- NOTE: this causes error:
    -- config = function(_, opts)
    --   require('config.treesitter').setup(opts)
    -- end,
  },
}
