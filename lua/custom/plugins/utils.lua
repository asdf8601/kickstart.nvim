-- toggle numbers
vim.g.number = 1
function ToggleNumbers()
  if vim.g.number == 1 then
    vim.g.number = 0
    vim.o.number = false
    vim.o.relativenumber = false
    vim.o.signcolumn = 'no'
  else
    vim.g.number = 1
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.signcolumn = 'yes'
  end
end
vim.api.nvim_create_user_command('ToggleNumbers', ToggleNumbers, {})

-- bucket
function GetVisual(mode)
  local data
  local _, ls, cs = unpack(vim.fn.getpos('v'))
  local _, le, ce = unpack(vim.fn.getpos('.'))
  if mode == 'V' then
      data = vim.api.nvim_buf_get_lines(0, ls-1, le-1, false)
  else
      data = vim.api.nvim_buf_get_text(0, ls-1, cs-1, le-1, ce, {})
  end
  return table.concat(data, '\\n')
end

local function GsutilImport()
  local bucket = ""
  local mode = vim.fn.mode()

  if mode == 'v' or mode == 'V' then
    bucket = GetVisual(mode)
  else
    bucket = vim.fn.expand('<cWORD>')
  end

  -- remove spaces, qoutes and new lines
  bucket = bucket:gsub('\\n', ''):gsub('%s+', ''):gsub('"', ''):gsub("'", '')

  if not string.match(bucket, "gs://") then
    vim.print("Not a valid bucket")
    return
  end

  local tmpfile = "/tmp/" .. string.match(bucket, "[^gs://].*$")
  local cmd = string.format("gsutil -m cp -r %s %s", bucket, tmpfile)
  vim.print(cmd)
  local out = vim.fn.system(cmd)
  vim.print(out)
  vim.cmd.edit(tmpfile)
end

vim.api.nvim_create_user_command("GsutilImport", GsutilImport, { nargs = 0 })
vim.api.nvim_set_keymap("n", "<leader>gg", ":GsutilImport<cr>", { noremap = true, silent = false })

-- Examples
-- ========
-- "gs://hola/mundo/que/tal/estas.txt"
-- 'gs://hola/mundo/que/tal/estas.txt'
-- gs://hola/mundo/que/tal/

return {
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  'tpope/vim-fugitive', -- git extension
  'tpope/vim-rhubarb',  -- github extension


  {
    -- resize window automatically
    "nvim-focus/focus.nvim",
    config = function()
      require('focus').setup({
        enable=false
      })
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  {
    'mbbill/undotree',
    init = function()
      vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { noremap = true, desc = "Open/close UndoTree" })
    end,
  },


  {
    'ThePrimeagen/harpoon',
    init = function()
      vim.keymap.set('n', '<C-s><C-h>', ':lua SendToHarpoon(1, 0)<CR>', { noremap = true, desc = "Send to Harpoon (normal mode)" })
      vim.keymap.set('v', '<C-s><C-h>', ':lua SendToHarpoon(1, 1)<CR>', { noremap = true, desc = "Send to Harpoon (visual mode)" })
      vim.keymap.set('n', '<C-h>', ':lua require("harpoon.ui").nav_file(1)<cr>', { noremap = true, desc = 'Harpoon file 1' })
      vim.keymap.set('n', '<C-j>', ':lua require("harpoon.ui").nav_file(2)<cr>', { noremap = true, desc = 'Harpoon file 2' })
      vim.keymap.set('n', '<C-k>', ':lua require("harpoon.ui").nav_file(3)<cr>', { noremap = true, desc = 'Harpoon file 3' })
      vim.keymap.set('n', '<C-l>', ':lua require("harpoon.ui").nav_file(4)<cr>', { noremap = true, desc = 'Harpoon file 4' })
      vim.keymap.set('n', '<C-h><C-h>', ':lua require("harpoon.term").gotoTerminal(1)<cr>i', { noremap = true, desc = "Harpoon Terminal 1" })
      vim.keymap.set('n', '<C-j><C-j>', ':lua require("harpoon.term").gotoTerminal(2)<cr>i', { noremap = true, desc = "Harpoon Terminal 2" })
      vim.keymap.set('n', '<C-k><C-k>', ':lua require("harpoon.term").gotoTerminal(3)<cr>i', { noremap = true, desc = "Harpoon Terminal 3" })
      vim.keymap.set('n', '<C-l><C-l>', ':lua require("harpoon.term").gotoTerminal(4)<cr>i', { noremap = true, desc = "Harpoon Terminal 4" })
      vim.keymap.set('n', '<leader>hh', ':lua require("harpoon.mark").add_file()<CR>', { desc = "Add file to Harpoon marks" })
      vim.keymap.set('n', '<leader>hm', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', { noremap = true, desc = "Harpoon's quick menu" })
    end,
  },
}

