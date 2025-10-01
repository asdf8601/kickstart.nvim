---@module 'blink.cmp'

---@class blink-jira.Options
---@field jira_project? string Project key to filter tickets (e.g., "PROJ")
---@field jira_status? string[] Status filter for tickets (e.g., {"In Progress", "To Do"})
---@field max_results? number Maximum number of tickets to fetch (default: 50)
---@field cache_duration? number Cache duration in seconds (default: 300)
---@field trigger_character? string Character that triggers Jira completion (default: "#")
---@field background_refresh? boolean Enable background cache refresh (default: true)
---@field debug? boolean Enable debug logging (default: false)
---@field cache_file? string Path to cache file (default: stdpath("cache")/blink-jira-cache.json)

---@class JiraSource : blink.cmp.Source, blink-jira.Options
---@field completion_items blink.cmp.CompletionItem[]
---@field cache_time number
---@field refresh_timer? number Timer ID for background refresh
---@field is_refreshing boolean Flag to prevent concurrent refreshes
---@field cache_file_path string Full path to cache file
local jira_source = {}

---Debug logging function
---@param self JiraSource
---@param level string
---@param message string
---@param data? any
local function debug_log(self, level, message, data)
  if not self.debug then
    return
  end

  local timestamp = os.date '%H:%M:%S'
  local prefix = string.format('[%s] blink-jira [%s]:', timestamp, level:upper())

  if data then
    vim.notify(string.format('%s %s\n%s', prefix, message, vim.inspect(data)), vim.log.levels.INFO)
  else
    vim.notify(string.format('%s %s', prefix, message), vim.log.levels.INFO)
  end
end

---Save cache to disk
---@param self JiraSource
local function save_cache_to_disk(self)
  if not self.cache_file_path or #self.completion_items == 0 then
    return
  end

  local cache_data = {
    completion_items = self.completion_items,
    cache_time = self.cache_time,
    version = '1.0', -- For future compatibility
    config_hash = vim.fn.sha256(vim.json.encode {
      jira_project = self.jira_project,
      jira_status = self.jira_status,
      max_results = self.max_results,
    }),
  }

  -- Ensure cache directory exists
  local cache_dir = vim.fn.fnamemodify(self.cache_file_path, ':h')
  vim.fn.mkdir(cache_dir, 'p')

  local ok, encoded = pcall(vim.json.encode, cache_data)
  if not ok then
    debug_log(self, 'error', 'Failed to encode cache data', { error = encoded })
    return
  end

  local file = io.open(self.cache_file_path, 'w')
  if not file then
    debug_log(self, 'error', 'Failed to open cache file for writing', { path = self.cache_file_path })
    return
  end

  file:write(encoded)
  file:close()

  debug_log(self, 'debug', 'Cache saved to disk', {
    path = self.cache_file_path,
    item_count = #self.completion_items,
    file_size = vim.fn.getfsize(self.cache_file_path),
  })
end

---Load cache from disk
---@param self JiraSource
---@return boolean success
local function load_cache_from_disk(self)
  if not self.cache_file_path or vim.fn.filereadable(self.cache_file_path) == 0 then
    debug_log(self, 'debug', 'Cache file not found or not readable', { path = self.cache_file_path })
    return false
  end

  local file = io.open(self.cache_file_path, 'r')
  if not file then
    debug_log(self, 'error', 'Failed to open cache file for reading', { path = self.cache_file_path })
    return false
  end

  local content = file:read '*a'
  file:close()

  if not content or content == '' then
    debug_log(self, 'error', 'Cache file is empty', { path = self.cache_file_path })
    return false
  end

  local ok, cache_data = pcall(vim.json.decode, content)
  if not ok or type(cache_data) ~= 'table' then
    debug_log(self, 'error', 'Failed to decode cache file', {
      path = self.cache_file_path,
      error = cache_data,
    })
    return false
  end

  -- Check if cache is compatible with current configuration
  local current_config_hash = vim.fn.sha256(vim.json.encode {
    jira_project = self.jira_project,
    jira_status = self.jira_status,
    max_results = self.max_results,
  })

  if cache_data.config_hash ~= current_config_hash then
    debug_log(self, 'info', 'Cache invalidated due to configuration change', {
      old_hash = cache_data.config_hash,
      new_hash = current_config_hash,
    })
    return false
  end

  -- Check if cache is expired
  local current_time = os.time()
  local cache_age = current_time - (cache_data.cache_time or 0)

  if cache_age > self.cache_duration then
    debug_log(self, 'info', 'Cache expired', {
      cache_age = cache_age,
      cache_duration = self.cache_duration,
    })
    return false
  end

  -- Load cache data
  if cache_data.completion_items and type(cache_data.completion_items) == 'table' then
    self.completion_items = cache_data.completion_items
    self.cache_time = cache_data.cache_time or current_time

    debug_log(self, 'info', 'Cache loaded from disk', {
      path = self.cache_file_path,
      item_count = #self.completion_items,
      cache_age = cache_age,
    })
    return true
  end

  debug_log(self, 'error', 'Invalid cache data structure', { path = self.cache_file_path })
  return false
end

---@param ticket_key string
---@param title string
---@param status string
---@param assignee string
---@param description? string
---@param ticket_key string
---@param title string
---@param status string
---@param assignee string
---@param description? any
---@return lsp.CompletionItem
local make_jira_completion_item = function(ticket_key, title, status, assignee, description)
  -- Handle description - it might be a table or string
  local desc_text = ''
  if description then
    if type(description) == 'string' then
      desc_text = description
    elseif type(description) == 'table' and description.content then
      -- Handle Atlassian Document Format (ADF)
      desc_text = vim.inspect(description.content):gsub('%s+', ' ')
    elseif type(description) == 'table' then
      desc_text = vim.inspect(description):gsub('%s+', ' ')
    end
  end

  -- Create a searchable text that includes key, title, and description
  local searchable_text = ticket_key .. ' ' .. title
  if desc_text and desc_text ~= '' then
    searchable_text = searchable_text .. ' ' .. desc_text
  end

  -- Format documentation with description if available
  local doc_parts = {
    string.format('**%s**', ticket_key),
    '',
    string.format('*Status:* %s', status),
    string.format('*Assignee:* %s', assignee or 'Unassigned'),
    '',
    title,
  }

  if desc_text and desc_text ~= '' then
    table.insert(doc_parts, '')
    table.insert(doc_parts, '**Description:**')
    table.insert(doc_parts, desc_text)
  end

  ---@type lsp.CompletionItem
  return {
    label = ticket_key,
    insertText = ticket_key,
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
    kind = require('blink.cmp.types').CompletionItemKind.Reference,
    detail = title,
    filterText = searchable_text, -- This allows filtering by key, title, and description
    -- Store raw data for lazy resolution
    data = {
      ticket_key = ticket_key,
      title = title,
      status = status,
      assignee = assignee,
      desc_text = desc_text,
    },
  }
end

---Execute jira-cli command asynchronously and return parsed results
---@param self JiraSource
---@param project? string
---@param status? string[]
---@param max_results? number
---@param callback fun(items: blink.cmp.CompletionItem[])
local function fetch_jira_tickets_async(self, project, status, max_results, callback)
  max_results = max_results or 50

  -- Build command using individual flags instead of JQL to avoid quoting issues
  local cmd_parts = { 'jira issue list' }

  -- Add project filter
  if project then
    table.insert(cmd_parts, string.format('-p "%s"', project))
  end

  -- Add status filters
  if status and #status > 0 then
    for _, s in ipairs(status) do
      table.insert(cmd_parts, string.format('-s "%s"', s))
    end
  else
    -- If no specific status, get current user's assigned issues
    table.insert(cmd_parts, '-a currentUser()')
  end

  -- Add pagination and raw output
  table.insert(cmd_parts, string.format('--paginate 0:%d', max_results))
  table.insert(cmd_parts, '--raw')

  local cmd = table.concat(cmd_parts, ' ')

  debug_log(self, 'info', 'Executing jira-cli command', {
    project = project,
    status = status,
    max_results = max_results,
    command = cmd,
  })

  local start_time = vim.loop.hrtime()

  -- Use vim.system for async execution (Neovim 0.10+)
  if vim.system then
    vim.system({ 'sh', '-c', cmd }, { text = true }, function(result)
      vim.schedule(function()
        local duration_ms = (vim.loop.hrtime() - start_time) / 1000000

        if result.code ~= 0 or not result.stdout or result.stdout == '' then
          debug_log(self, 'error', 'jira-cli command failed', {
            exit_code = result.code,
            stderr = result.stderr,
            duration_ms = duration_ms,
          })
          callback {}
          return
        end

        local ok, tickets = pcall(vim.fn.json_decode, result.stdout)
        if not ok or type(tickets) ~= 'table' then
          debug_log(self, 'error', 'Failed to parse JSON response', {
            error = tickets,
            raw_output = result.stdout:sub(1, 200) .. (result.stdout:len() > 200 and '...' or ''),
            duration_ms = duration_ms,
          })
          callback {}
          return
        end

        local completion_items = {}
        for _, ticket in ipairs(tickets) do
          if ticket.key and ticket.fields then
            local item = make_jira_completion_item(
              ticket.key,
              ticket.fields.summary or 'No title',
              ticket.fields.status and ticket.fields.status.name or 'Unknown',
              ticket.fields.assignee and ticket.fields.assignee.displayName,
              ticket.fields.description
            )
            table.insert(completion_items, item)
          end
        end

        debug_log(self, 'info', 'Successfully fetched Jira tickets', {
          ticket_count = #completion_items,
          duration_ms = duration_ms,
          sample_tickets = vim.tbl_map(function(item)
            return item.label
          end, vim.list_slice(completion_items, 1, 3)),
        })

        callback(completion_items)
      end)
    end)
  else
    -- Fallback to synchronous execution wrapped in vim.schedule
    vim.schedule(function()
      local handle = io.popen(cmd)
      if not handle then
        debug_log(self, 'error', 'Failed to execute jira-cli command (handle is nil)')
        callback {}
        return
      end

      local result = handle:read '*a'
      handle:close()

      local duration_ms = (vim.loop.hrtime() - start_time) / 1000000

      if not result or result == '' then
        debug_log(self, 'error', 'jira-cli command returned empty result', {
          duration_ms = duration_ms,
        })
        callback {}
        return
      end

      local ok, tickets = pcall(vim.fn.json_decode, result)
      if not ok or type(tickets) ~= 'table' then
        debug_log(self, 'error', 'Failed to parse JSON response (fallback)', {
          error = tickets,
          raw_output = result:sub(1, 200) .. (result:len() > 200 and '...' or ''),
          duration_ms = duration_ms,
        })
        callback {}
        return
      end

      local completion_items = {}
      for _, ticket in ipairs(tickets) do
        if ticket.key and ticket.fields then
          local item = make_jira_completion_item(
            ticket.key,
            ticket.fields.summary or 'No title',
            ticket.fields.status and ticket.fields.status.name or 'Unknown',
            ticket.fields.assignee and ticket.fields.assignee.displayName,
            ticket.fields.description
          )
          table.insert(completion_items, item)
        end
      end

      debug_log(self, 'info', 'Successfully fetched Jira tickets (fallback)', {
        ticket_count = #completion_items,
        duration_ms = duration_ms,
        sample_tickets = vim.tbl_map(function(item)
          return item.label
        end, vim.list_slice(completion_items, 1, 3)),
      })

      callback(completion_items)
    end)
  end
end

---Start background cache refresh
---@param self JiraSource
local function start_background_refresh(self)
  if not self.background_refresh or self.refresh_timer then
    return
  end

  local refresh_interval = math.max(self.cache_duration * 1000 / 2, 30000) -- Half cache duration, min 30s

  debug_log(self, 'info', 'Starting background cache refresh', {
    refresh_interval_ms = refresh_interval,
    cache_duration = self.cache_duration,
  })

  self.refresh_timer = vim.fn.timer_start(refresh_interval, function()
    if self.is_refreshing then
      debug_log(self, 'debug', 'Skipping background refresh - already in progress')
      return
    end

    debug_log(self, 'debug', 'Starting background cache refresh')
    self.is_refreshing = true
    fetch_jira_tickets_async(self, self.jira_project, self.jira_status, self.max_results, function(items)
      self.completion_items = items
      self.cache_time = os.time()
      self.is_refreshing = false
      save_cache_to_disk(self)
      debug_log(self, 'debug', 'Background cache refresh completed', {
        item_count = #items,
      })
    end)
  end, { ['repeat'] = -1 })
end

---Stop background cache refresh
---@param self JiraSource
local function stop_background_refresh(self)
  if self.refresh_timer then
    debug_log(self, 'info', 'Stopping background cache refresh', {
      timer_id = self.refresh_timer,
    })
    vim.fn.timer_stop(self.refresh_timer)
    self.refresh_timer = nil
  end
end

---@param opts blink-jira.Options
function jira_source.new(opts)
  opts = opts or {}

  -- Validate options
  vim.validate('blink-jira.opts.jira_project', opts.jira_project, { 'string' }, true)
  vim.validate('blink-jira.opts.jira_status', opts.jira_status, { 'table' }, true)
  vim.validate('blink-jira.opts.max_results', opts.max_results, { 'number' }, true)
  vim.validate('blink-jira.opts.cache_duration', opts.cache_duration, { 'number' }, true)
  vim.validate('blink-jira.opts.trigger_character', opts.trigger_character, { 'string' }, true)
  vim.validate('blink-jira.opts.background_refresh', opts.background_refresh, { 'boolean' }, true)
  vim.validate('blink-jira.opts.debug', opts.debug, { 'boolean' }, true)
  vim.validate('blink-jira.opts.cache_file', opts.cache_file, { 'string' }, true)

  ---@type blink-jira.Options
  local default_opts = {
    max_results = 50,
    cache_duration = 300,
    trigger_character = '#',
    background_refresh = true,
    debug = false,
  }

  opts = vim.tbl_deep_extend('keep', opts, default_opts)
  opts.completion_items = {}
  opts.cache_time = 0
  opts.is_refreshing = false

  -- Set up cache file path
  if not opts.cache_file then
    local cache_dir = vim.fn.stdpath 'cache'
    opts.cache_file_path = cache_dir .. '/blink-jira-cache.json'
  else
    opts.cache_file_path = opts.cache_file
  end

  local instance = setmetatable(opts, { __index = jira_source })

  debug_log(
    instance,
    'info',
    'Initializing blink-jira source',
    vim.tbl_extend('force', opts, {
      cache_file_path = instance.cache_file_path,
    })
  )

  -- Try to load cache from disk first
  local cache_loaded = load_cache_from_disk(instance)

  -- Start background refresh if enabled
  if opts.background_refresh then
    start_background_refresh(instance)

    -- Initial cache load only if no valid cache was loaded from disk
    if not cache_loaded then
      debug_log(instance, 'info', 'No valid disk cache found, loading initial cache from API')
      instance.is_refreshing = true
      fetch_jira_tickets_async(instance, instance.jira_project, instance.jira_status, instance.max_results, function(items)
        instance.completion_items = items
        instance.cache_time = os.time()
        instance.is_refreshing = false
        save_cache_to_disk(instance)
        debug_log(instance, 'info', 'Initial cache load completed', {
          item_count = #items,
        })
      end)
    end
  elseif not cache_loaded then
    -- If background refresh is disabled and no cache loaded, we'll fetch on first use
    debug_log(instance, 'info', 'Background refresh disabled and no cache loaded - will fetch on first use')
  end

  return instance
end

-- (Optional) Non-alphanumeric characters that trigger the source
function jira_source:get_trigger_characters()
  return { self.trigger_character or '#' }
end

---@param context blink.cmp.Context
function jira_source:get_completions(context, callback)
  local cancelled = false

  -- Check if the trigger character is present
  local trigger_char = self.trigger_character or '#'
  local line_before_cursor = context.line:sub(1, context.cursor[2])

  -- Look for the trigger character
  local trigger_pos = line_before_cursor:find(trigger_char .. '[^%s]*$')
  if not trigger_pos then
    debug_log(self, 'debug', 'No trigger character found', {
      trigger_char = trigger_char,
      line_before_cursor = line_before_cursor,
    })
    return function()
      cancelled = true
    end -- return cancellation function
  end

  debug_log(self, 'debug', 'Trigger character detected, providing completions', {
    trigger_char = trigger_char,
    trigger_pos = trigger_pos,
    cached_items = #self.completion_items,
  })

  local current_time = os.time()
  local cache_age = current_time - self.cache_time

  debug_log(self, 'debug', 'Cache status', {
    cache_age = cache_age,
    cache_duration = self.cache_duration,
    is_expired = cache_age > self.cache_duration,
    background_refresh = self.background_refresh,
    is_refreshing = self.is_refreshing,
  })

  -- If background refresh is disabled or cache is expired, refresh manually
  if not self.background_refresh and (current_time - self.cache_time > self.cache_duration or #self.completion_items == 0) then
    if not self.is_refreshing then
      debug_log(self, 'info', 'Starting manual cache refresh')
      self.is_refreshing = true
      fetch_jira_tickets_async(self, self.jira_project, self.jira_status, self.max_results, function(items)
        if cancelled then
          debug_log(self, 'debug', 'Request cancelled, ignoring results')
          return
        end

        self.completion_items = items
        self.cache_time = current_time
        self.is_refreshing = false
        save_cache_to_disk(self)

        debug_log(self, 'info', 'Manual cache refresh completed, returning items', {
          item_count = #items,
        })

        callback {
          is_incomplete_forward = false,
          is_incomplete_backward = false,
          items = vim.deepcopy(items),
        }
      end)
      return function()
        cancelled = true
      end
    end
  end

  -- Always return cached items immediately (non-blocking)
  debug_log(self, 'debug', 'Returning cached items', {
    item_count = #self.completion_items,
  })

  -- NOTE: blink.cmp will mutate the items, so we must vim.deepcopy them
  callback {
    is_incomplete_forward = false,
    is_incomplete_backward = false,
    items = vim.deepcopy(self.completion_items),
  }

  return function()
    cancelled = true
  end
end

-- (Optional) Before accepting the item or showing documentation, blink.cmp will call this function
-- so you may avoid calculating expensive fields (i.e. documentation) for only when they're actually needed
function jira_source:resolve(item, callback)
  item = vim.deepcopy(item)

  if item.data then
    local data = item.data
    local doc_parts = {
      string.format('**%s**', data.ticket_key),
      '',
      string.format('*Status:* %s', data.status),
      string.format('*Assignee:* %s', data.assignee or 'Unassigned'),
      '',
      data.title,
    }

    if data.desc_text and data.desc_text ~= '' then
      table.insert(doc_parts, '')
      table.insert(doc_parts, '**Description:**')
      table.insert(doc_parts, data.desc_text)
    end

    -- Shown in the documentation window (<C-space> when menu open by default)
    item.documentation = {
      kind = 'markdown',
      value = table.concat(doc_parts, '\n'),
    }
  end

  callback(item)
end

---Clean up resources when source is destroyed
function jira_source:destroy()
  debug_log(self, 'info', 'Destroying blink-jira source')
  stop_background_refresh(self)
end

return jira_source
