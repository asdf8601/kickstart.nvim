# blink-jira

A Neovim plugin that provides Jira ticket autocompletion for blink.cmp using jira-cli.

## Requirements

- Neovim 0.9+
- [blink.cmp](https://github.com/Saghen/blink.cmp)
- [jira-cli](https://github.com/ankitpokhrel/jira-cli)

## Installation

Install using your preferred package manager:

```lua
-- lazy.nvim
{
  'your-username/blink-jira',
  dependencies = {
    'Saghen/blink.cmp'
  }
}
```

## Setup

Add to your blink.cmp configuration:

```lua
require('blink.cmp').setup({
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer', 'jira' },
    providers = {
      jira = {
        name = 'blink-jira',
        module = 'blink-jira'
      }
    }
  }
})
```

## Usage

Type `#` followed by your search term to trigger Jira ticket completion.

## Configuration

```lua
require('blink.cmp').setup({
  sources = {
    providers = {
      jira = {
        name = 'blink-jira',
        module = 'blink-jira',
        opts = {
          jira_project = 'PROJ',                    -- Filter by project
          jira_status = {'In Progress', 'To Do'},   -- Filter by status
          max_results = 50,                         -- Maximum tickets to fetch
          cache_duration = 300,                     -- Cache lifetime in seconds
          trigger_character = '#',                  -- Trigger character
          background_refresh = true,                -- Auto-refresh cache
          debug = false                             -- Enable debug logging
        }
      }
    }
  }
})
```

## Features

- Fast autocompletion with persistent caching
- Background cache refresh
- Configurable filters for project and status
- Rich completion items with status and assignee info
- Debug mode for troubleshooting

## License

MIT