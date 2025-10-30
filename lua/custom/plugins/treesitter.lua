local branch = 'main'
local filetypes_ensure_installed = {
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
  'jsonnet',
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
    main = 'nvim-treesitter.config', -- Sets main module to use for opts
    opts = {
      ensure_installed = filetypes_ensure_installed,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      require('nvim-treesitter.config').setup(opts)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes_ensure_installed,
        callback = function()
          vim.treesitter.start()
        end,
      })
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = branch,
  },
}
