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
    build = ':TSUpdate',
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
    -- config = function(_, opts)
    --   require("nvim-treesitter.configs").setup(opts)
    -- end,
  },
}
