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
  'git_config',
  'gitattributes',
  'git_rebase',
  'diff',
  'gitcommit', -- requires git_rebase and diff https://github.com/gbprod/tree-sitter-gitcommit#note-about-injected-languages
  'gitignore',
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
    -- config = function(_, opts)
    --   -- require('nvim-tresitter').setup()
    --   require'nvim-treesitter'.install(filetypes_ensure_installed)
    --   require('nvim-treesitter.config').setup(opts)
    --
    --
    --   vim.treesitter.language.register('markdown', 'mdx')
    --   vim.treesitter.language.register('bash', 'zsh')
    --
    --   vim.api.nvim_create_autocmd('FileType', {
    --     pattern = '*',
    --     callback = function(args)
    --       local filetype = args.match
    --       local parser_name = vim.treesitter.language.get_lang(filetype)
    --
    --       if not parser_name then
    --         return
    --       end
    --
    --       if not pcall(vim.treesitter.get_parser, args.buf, parser_name) then
    --         return
    --       end
    --
    --       vim.treesitter.start()
    --       vim.wo.foldmethod = 'expr'
    --       vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    --       vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    --     end,
    --   })
    -- end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = branch,
  },
}
