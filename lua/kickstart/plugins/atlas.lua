return {
  {
    -- review PRs and issues (GitHub via gh, Jira, ...) inside nvim
    'emrearmagan/atlas.nvim',
    cmd = 'Atlas',
    keys = {
      { '<leader>gr', '<cmd>Atlas review .<cr>', desc = 'atlas: review current branch PR' },
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'sindrets/diffview.nvim',
    },
    opts = {
      providers = {
        github = {},
      },
      pulls = {
        -- Atlas's own viewer: one buffer (inline), `t` toggles side by side.
        diff = { open_cmd = 'AtlasDiff' },
      },
      keymaps = {
        -- Inside the diff, <leader>gr toggles inline <-> side by side;
        -- outside it, the global <leader>gr above opens the review.
        pulls = { review = { atlas = { toggle_layout = { 't', '<leader>gr' } } } },
      },
    },
  },
}
