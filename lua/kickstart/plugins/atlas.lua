return {
  {
    -- review PRs and issues (GitHub via gh, Jira, ...) inside nvim
    'emrearmagan/atlas.nvim',
    cmd = 'Atlas',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'sindrets/diffview.nvim',
    },
    opts = {
      providers = {
        github = {},
      },
    },
  },
}
