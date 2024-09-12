-- create a new buffer with the name of the file
local druidConfig = {
  pattern = "*druidq/*.sql",
  bin = "druidq",
  opts = { "-eprint(df.to_string())" },
  outSuffix = ".out",
}

local trinoConfig = {
  pattern = "*trinoq/*.sql",
  bin = "trinoq",
  opts = { "-eprint(df.to_string())" },
  outSuffix = ".out",
}

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
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
      end,

      on_stderr = function (_, data, _)
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {"Error:"})
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
      end
    })
  end
  return callback
end


vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("AutoSql", { clear = true }),
  pattern = druidConfig.pattern,
  callback = CallbackFactory(trinoConfig)
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("AutoSql", { clear = true }),
  pattern = trinoConfig.pattern,
  callback = CallbackFactory(trinoConfig)
})
-- vim: set sw=2 ts=2 sts=2 et:
