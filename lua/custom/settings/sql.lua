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
      -- vim.cmd.write()
      bufnr = vim.fn.bufnr(bufoutname)
    end

    local cmd = { config.cmd, bufname, }

    for _, opt in ipairs(config.args) do
      table.insert(cmd, opt)
    end

    -- clean buffer
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

    -- execute command
    vim.fn.jobstart(cmd, {
      stdout_buffered = false,

      on_stdout = function(_, data, _)
        -- NOTE:
        -- this function is called multiple times that's why we need to
        -- append the data.
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
      end,

      on_stderr = function (_, data, _)
        -- NOTE:
        -- this function is called always multiple times that's why we
        -- need to append the Error line and the data.
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

local function mergeConfigs(userConfig, defaultConfig)
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


local druidConfigDefault = {
  cmd = "druidq",
  args = {},
  outSuffix = ".out",
  pattern = "*druidq/*.sql",
  event = "BufWritePost",
  group = "AutoSql",
}


local trinoConfigDefault = {
  cmd = "trinoq",
  args = {},
  outSuffix = ".out",
  pattern = "*trinoq/*.sql",
  event = "BufWritePost",
  group = "AutoSql",
}


function SqlEnable(config)

  if config == 'druid' then
    config = { druid = {} }
    local druid = mergeConfigs(config.druid, druidConfigDefault)
    autocmdFactory(druid)

  elseif config == 'trino' then
    config = { trino = {} }
    local trino = mergeConfigs(config.trino, trinoConfigDefault)
    autocmdFactory(trino)
  end

end


function ClearGroup(group)
  vim.api.nvim_clear_autocmds({group = group})
end


function SqlDisable()
  local group = "AutoSql"
  ClearGroup(group)
end



return {}
-- vim: set sw=2 ts=2 sts=2 et:
