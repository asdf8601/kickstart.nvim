-- Description:
-- This file contains the configuration to run the sql queries automatically
-- when the file is saved and display the output in a new buffer under the same
-- name with the suffix .out.
-- It contains two configurations, one for druid and one for trino.
function CallbackFactory(config)
  local callback = function()

    local bufname = vim.fn.expand("%:p")
    local bufoutname = bufname .. config.outSuffix
    local bufnr = vim.fn.bufnr(bufoutname)

    if bufnr == -1 then
      vim.cmd.new(bufoutname)
      bufnr = vim.fn.bufnr(bufoutname)
    end

    -- build cmd
    local cmd = { config.cmd, bufname, }
    for _, opt in ipairs(config.opts) do
      table.insert(cmd, opt)
    end

    -- clean entire buffer
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

    -- execute command
    vim.fn.jobstart(cmd, {
      on_stdout = function(_, data, _)
        -- Append data in multiple calls (-1, -1)
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
      end,

      on_stderr = function (_, data, _)
        -- Append data in multiple calls (-1, -1)
        if data then
          -- vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {"Error:"})
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


local pythonConfigDefault = {
  -- Pattern:
  --   $ <bin> (<file>) <ops> > <file>.out
  -- Equivalent to:
  --   $ python % > %.out
  pattern = "*.py",
  cmd = "python",
  opts = {},
  outSuffix = ".out",
  group = "AutoPython",
  event = "BufWritePost",
}

function RunnerRemove(config)
  ClearGroup(config.group)
end


function RunnerNew(config)
  -- NOTE:
  -- this function will create an autocmd group for the python files
  -- and run the python code when the file is saved.
  -- Usage:
  -- CreateRunner({pattern = "*.py", bin = "python %"})
  config = mergeConfigs(config, pythonConfigDefault)
  autocmdFactory(config)
end


return {}
-- vim: set sw=2 ts=2 sts=2 et:
