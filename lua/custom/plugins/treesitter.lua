local branch = 'master'
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
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = branch,
    -- NOTE: this causes error on main
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
      ensure_installed = ensure_installed,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- NOTE: this causes error on main
    config = function(_, opts)
      -- require('config.treesitter').setup(opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = branch,
  },
}
