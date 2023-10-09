
-- [[ telescope ]]  {{
pcall(require('telescope').load_extension, 'media_files')
-- require('telescope').load_extension('media_files')
local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<C-p>', builtin.git_files, { noremap = true, desc = 'Find files in git repo' })
vim.keymap.set('n', '<leader>gs', builtin.git_stash, { noremap = true, desc = 'Git stash' })
-- local ignore_patterns = {
--   '^.npm/',
--   '^.zsh%/',
--   '^.oh-my-zsh/',
--   '^.cache/',
--   '^.tmux/',
--   '/venv/',
--   '.venv/',
--   '.git/',
--   'node_modules/',
--   '*.pyc',
--   'cache',
--   '%.pkl',
--   '%.pickle',
--   '%.mat',
-- }
local actions = require('telescope.actions')

local function search_scio()
  -- function to edit a file
  local vim_edit_prompt = function(prompt_bufnr)
    local current_picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
    local prompt = current_picker:_get_prompt()
    local cwd = current_picker.cwd
    actions.close(prompt_bufnr)
    vim.cmd('edit ' .. cwd .. '/' .. prompt)
    return true
  end
  require("telescope.builtin").find_files({
    prompt_title = "< scio >",
    cwd = "~/github/mmngreco/scio",
    hidden = true,
    no_ignore = true,
    attach_mappings = function(_, map)
      map('i', '<c-n>', vim_edit_prompt)
      return true
    end
  })
end

local function search_dotfiles()
  require("telescope.builtin").find_files({
    prompt_title = "< dotfiles >",
    cwd = "$DOTFILES_HOME",
    hidden = true,
    no_ignore = true,
  })
end

local function my_find_files()
  require("telescope.builtin").find_files({
    -- file_ignore_patterns = ignore_patterns,
    hidden = true,
    no_ignore = true,
    follow = true,
  })
end

local function git_branches()
  require("telescope.builtin").git_branches({
    attach_mappings = function(_, map)
      map('i', '<c-d>', actions.git_delete_branch)
      map('n', '<c-d>', actions.git_delete_branch)
      map('i', '<c-b>', actions.git_create_branch)
      return true
    end
  })
end

require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
  },
  pickers = {
    buffers = {
      mappings = {
        i = {
          ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
        }
      }
    }
  }
}

local function find_files_from_project_git_root()
  local function is_git_repo()
    vim.fn.system("git rev-parse --is-inside-work-tree")
    return vim.v.shell_error == 0
  end
  local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
  end
  local opts = {
    -- file_ignore_patterns = ignore_patterns,
    hidden = true,
  }
  if is_git_repo() then
    opts["cwd"] = get_git_root()
  end
  require("telescope.builtin").find_files(opts)
end

vim.keymap.set("n", "<C-p>", find_files_from_project_git_root, { noremap = true, desc = "Find files from git root" })
-- vim.keymap.set('n', '<leader>fh', ':Telescope <cr>', { noremap = true, desc = "Find help", silent = false })
vim.keymap.set('n', '<leader>fl', ':Telescope diagnostics<cr>', { noremap = true, desc = "Find errors, lint, diagnostics", silent = false })
vim.keymap.set('n', '<leader>fc', ':Telescope commands<cr>', { noremap = true, desc = "Find commands", silent = false })
vim.keymap.set('n', '<leader>fk', ':Telescope keymaps<cr>', { noremap = true, desc = "Find keymaps", silent = false })
vim.keymap.set('n', '<Leader>ff', my_find_files, { desc = "Find files", noremap = true })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>dot', search_dotfiles, { desc = "Search dotfiles", noremap = true })
vim.keymap.set('n', '<leader>gc', git_branches, { desc = "Git branches", noremap = true })
vim.keymap.set('n', '<leader>sc', search_scio, { desc = "Search scio", noremap = true })
vim.keymap.set('n', "<leader>fp", "<cmd>lua require('telescope.builtin').find_files( { cwd = vim.fn.expand('%:p:h'), hidden = false }) <CR>", { desc = "Search current buffer dir", noremap = true })
vim.keymap.set('n', "ts", "<cmd>lua require('telescope.builtin').symbols{ sources = {'emoji', 'kaomoji', 'gitmoji'} } <CR>", { desc = "Search emoji", noremap = true })



local previewers = require("telescope.previewers")

local new_maker = function(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.expand(filepath)
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then return end
    if stat.size > 100000 then
      return
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

require("telescope").setup {
  defaults = {
    buffer_previewer_maker = new_maker,
    -- file_ignore_patterns=ignore_patterns,
  }
}

-- }}
