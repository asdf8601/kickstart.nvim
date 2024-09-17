-- Description:
-- This file contains the configuration to run the sql queries automatically
-- when the file is saved and display the output in a new buffer under the same
-- name with the suffix .out.
-- It contains two configurations, one for druid and one for trino.
function CallbackFactory(config)
  local callback = function()
    -- get current buffer name
    local bufname = vim.fn.expand("%:p")
    -- get the output buffer name
    local bufoutname = bufname .. config.outSuffix
    local bufnr = vim.fn.bufnr(bufoutname)
    if bufnr == -1 then
      vim.cmd.new(bufoutname)
      -- vim.cmd.write()
      bufnr = vim.fn.bufnr(bufoutname)
    end
    -- create the command
    local cmd = { config.bin, bufname, }
    for _, opt in ipairs(config.opts) do
      table.insert(cmd, opt)
    end

    -- clean buffer
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

    -- execute command
    vim.fn.jobstart(cmd, {
      stdout_buffered = false,

      on_stdout = function(_, data, _)
        -- NOTE: this function is called multiple times that's why we need to
        -- append the data.
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
      end,

      on_stderr = function (_, data, _)
        -- NOTE: this function is called always multiple times that's why we
        -- need to append the Error line and the data.
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {"Error:"})
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
      end
    })
  end
  return callback
end

local autocmdFactory = function(event, config, augroup)
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
  pattern = "*druidq/*.sql",
  bin = "druidq",
  opts = {},
  outSuffix = ".out",
}

local trinoConfigDefault = {
  pattern = "*trinoq/*.sql",
  bin = "trinoq",
  opts = {},
  outSuffix = ".out",
}


function SqlEnable(config)
  local trino = mergeConfigs(config.trino, trinoConfigDefault)
  local druid = mergeConfigs(config.druid, druidConfigDefault)

  local augroup = vim.api.nvim_create_augroup("AutoSql", { clear = true })

  if druid then
    autocmdFactory("BufWritePost", druid, augroup)
  end

  if trino then
    autocmdFactory("BufWritePost", trino, augroup)
  end

end

function SqlDisable()
  vim.api.nvim_clear_autocmds({group = "AutoSql"})
end

SqlEnable({trino=trinoConfigDefault, druid=druidConfigDefault})
-- vim: set sw=2 ts=2 sts=2 et:
