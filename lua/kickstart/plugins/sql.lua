-- create a new buffer with the name of the file
local prj = "trinoq"
local pattern = "*"..prj.."/*.sql"
local bin = "trinoq"
local opts = { "-eprint(df.to_string())" }

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("AutoSql", { clear = true }),
  pattern = pattern,

  callback = function()
    -- get current buffer name
    local bufname = vim.fn.expand("%:p")
    -- get the output buffer name
    local bufoutname = bufname .. ".out"
    local bufnr = vim.fn.bufnr(bufoutname)
    if bufnr == -1 then
      vim.cmd.new(bufoutname)
      -- vim.cmd.write()
      bufnr = vim.fn.bufnr(bufoutname)
    end
    -- create the command
    local cmd = { bin, bufname, }
    for _, opt in ipairs(opts) do
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
      end,

    })
  end

})
-- vim: set sw=2 ts=2 sts=2 et:
