-- Description:
-- This file contains the configuration to run commands automatically
-- when the file is saved and display the output in a new buffer under the same
-- name with the suffix .out.

function CallbackFactory(config)
  local callback = function()
    local bufname = vim.fn.expand("%:p")
    local bufoutname = bufname .. config.outSuffix
    local bufnr = vim.fn.bufnr(bufoutname)

    if bufnr == -1 then
      vim.cmd.new(bufoutname)
      bufnr = vim.fn.bufnr(bufoutname)
      vim.api.nvim_set_option_value("textwidth", 100000, {buf=bufnr})
      vim.api.nvim_set_option_value("wrapmargin", 0, {buf=bufnr})
      vim.api.nvim_set_option_value("buftype", "nofile", {buf=bufnr})
    end

    -- build cmd
    local cmd = {}
    if type(config.cmd) == "string" then
      -- Split the command string into parts
      for part in config.cmd:gmatch("%S+") do
        if part == "%" then
          table.insert(cmd, bufname)
        else
          table.insert(cmd, part)
        end
      end
    else
      cmd = { config.cmd, bufname }
    end

    for _, opt in ipairs(config.opts) do
      table.insert(cmd, opt)
    end

    -- clean entire buffer
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

    -- execute command
    vim.fn.jobstart(cmd, {
      on_stdout = function(_, data, _)
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
      end,

      on_stderr = function (_, data, _)
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
      end
    })
  end
  return callback
end

local autocmdFactory = function(config)
  local event = config.event
  local augroup = vim.api.nvim_create_augroup(config.group, { clear = true })

  vim.api.nvim_create_autocmd(event, {
    group = augroup,
    pattern = config.pattern,
    callback = CallbackFactory(config)
  })
end

local mergeConfigs = function(userConfig, defaultConfig)
  local result = {}

  for k, v in pairs(defaultConfig) do
    result[k] = v
  end

  if userConfig == nil then
    return result
  end

  for k, v in pairs(userConfig) do
    result[k] = v
  end
  return result
end

function ClearGroup(group)
  vim.api.nvim_clear_autocmds({group = group})
end

---@type table @default configuration
local defaultConfig = {
  pattern = "*",
  cmd = "uv run %",
  opts = {},
  outSuffix = ".out",
  group = "AutoRunner",
  event = "BufWritePost",
}

function RunnerRemove(config)
  ClearGroup(config.group)
end

function RunnerNew(config)
  config = mergeConfigs(config, defaultConfig)
  autocmdFactory(config)
end


return {}
