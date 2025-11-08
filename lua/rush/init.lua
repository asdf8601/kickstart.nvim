local M = {}

-- Counter to generate unique buffer names
local buffer_counter = 0

-- History of executed commands
local command_history = {}

-- Map to associate buffers with their commands
local buffer_to_command = {}

---
-- Helper function that executes in the main thread.
-- Creates a scratch buffer and displays the output.
---
local function update_buffer_safely(win_id, lines, exit_code, cmd_string, origin_buf_id)
  -- 1. Create a new buffer for each execution
  local buf_id = vim.api.nvim_create_buf(true, true)
  buffer_counter = buffer_counter + 1

  -- 2. Configure buffer options
  vim.api.nvim_buf_set_option(buf_id, 'bufhidden', 'hide')
  vim.api.nvim_buf_set_option(buf_id, 'swapfile', false)
  vim.api.nvim_buf_set_option(buf_id, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf_id, 'wrap', false)

  -- 3. Assign unique name to buffer
  local buf_name = string.format("[Rush #%d] %s", buffer_counter, cmd_string:sub(1, 50))
  pcall(vim.api.nvim_buf_set_name, buf_id, buf_name)

  -- 4. Associate buffer with its command
  buffer_to_command[buf_id] = cmd_string

  -- 5. Configure keybinds
  vim.api.nvim_buf_set_keymap(buf_id, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(
    buf_id,
    'n',
    'r',
    string.format(':Rush %s<CR>', vim.fn.escape(cmd_string, ' \\')),
    { noremap = true, silent = true }
  )

  -- 6. Put content in buffer
  vim.api.nvim_buf_set_text(buf_id, 0, 0, -1, 0, lines)

  -- 7. Make buffer non-modifiable (read-only)
  vim.api.nvim_buf_set_option(buf_id, 'modifiable', false)

  -- 8. Save to history
  table.insert(command_history, {
    id = buffer_counter,
    command = cmd_string,
    exit_code = exit_code,
    buffer_id = buf_id,
    origin_buffer_id = origin_buf_id,
    timestamp = os.date('%Y-%m-%d %H:%M:%S'),
  })

  -- 9. Display buffer in a new horizontal split
  if not vim.api.nvim_win_is_valid(win_id) then
    win_id = vim.api.nvim_get_current_win()
  end

  vim.api.nvim_set_current_win(win_id)
  vim.cmd('split')
  vim.api.nvim_win_set_buf(0, buf_id)

  -- 10. Print final status message
  if exit_code == 0 then
    print(string.format("Command completed: %s", cmd_string))
  else
    print(string.format("Command failed (code %d): %s", exit_code, cmd_string))
  end
end

---
-- Command :Rush (Asynchronous and safe version)
---
vim.api.nvim_create_user_command('Rush', function(opts)
  local cmd_string = vim.fn.expandcmd(opts.args)
  local output_lines = {}

  local win_id = vim.api.nvim_get_current_win()
  local origin_buf_id = vim.api.nvim_get_current_buf()

  print(string.format("Executing: %s", cmd_string))

  vim.fn.jobstart({ 'sh', '-c', cmd_string }, {
    stdout_buffered = true,
    stderr_buffered = true,

    on_stdout = function(job_id, data)
      for _, line in ipairs(data) do
        if line ~= "" then
          table.insert(output_lines, line)
        end
      end
    end,

    on_stderr = function(job_id, data)
      for _, line in ipairs(data) do
        if line ~= "" then
          table.insert(output_lines, "[ERROR] " .. line)
        end
      end
    end,

    on_exit = function(job_id, exit_code, event)
      if #output_lines == 0 then
        table.insert(output_lines, string.format("Command (code %d) with no output.", exit_code))
      end

      vim.schedule_wrap(update_buffer_safely)(win_id, output_lines, exit_code, cmd_string, origin_buf_id)
    end,
  })
end, { nargs = '+', complete = 'shellcmd' })

---
-- Command :RushList - Show command history in quickfix
---
vim.api.nvim_create_user_command('RushList', function()
  if #command_history == 0 then
    print("No commands in history")
    return
  end

  local qf_list = {}
  for _, entry in ipairs(command_history) do
    local status = entry.exit_code == 0 and "✓" or "✗"
    local origin_name = ""
    if entry.origin_buffer_id and vim.api.nvim_buf_is_valid(entry.origin_buffer_id) then
      origin_name = vim.api.nvim_buf_get_name(entry.origin_buffer_id)
      if origin_name == "" then
        origin_name = string.format("[Buffer %d]", entry.origin_buffer_id)
      end
    else
      origin_name = "[Unknown buffer]"
    end

    table.insert(qf_list, {
      bufnr = entry.buffer_id,
      lnum = 1,
      text = string.format("%s | %s %s | %s", entry.timestamp, status, entry.command, origin_name),
    })
  end

  vim.fn.setqflist(qf_list, 'r')
  vim.cmd('copen')
end, {})

return M
