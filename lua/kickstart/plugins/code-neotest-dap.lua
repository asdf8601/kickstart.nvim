local py_config = {
  dap = { justMyCode = false },
  args = { '--capture', 'no' },
  runner = 'pytest',
}

local go_config = {
  runner = 'gotestsum',
  go_test_args = {
    '-count=1',
    '-p=1',
    '-parallel=10',
    '-race',
    '-tags=unit,integration',
    '-v',
  },
  go_list_args = { '-tags=unit,integration' },
  warn_test_name_dupes = false,
}

return {

  {
    'nvim-neotest/neotest',
    dependencies = {
      'antoinemadec/FixCursorHold.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-neotest/neotest-plenary',
      'nvim-neotest/neotest-python',
      'nvim-neotest/neotest-vim-test',
      'nvim-neotest/nvim-nio',
      {
        'nvim-treesitter/nvim-treesitter', -- Optional, but recommended
        branch = 'main', -- NOTE; not the master branch!
        build = function()
          vim.cmd ':TSUpdate go'
        end,
      },
      {
        'fredrikaverpil/neotest-golang',
        dependencies = {
          'leoluz/nvim-dap-go',
        },
        version = '*', -- Optional, but recommended; track releases
        build = function()
          vim.system({ 'go', 'install', 'gotest.tools/gotestsum@latest' }):wait() -- Optional, but recommended
        end,
        warn_test_name_dupes = false,
      },
    },
    keys = {
      {
        '<leader>ta',
        function()
          require('neotest').run.attach()
        end,
        desc = '[t]est [a]ttach',
      },
      {
        '<leader>tf',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = '[t]est run [f]ile',
      },
      {
        '<leader>tA',
        function()
          require('neotest').run.run(vim.uv.cwd())
        end,
        desc = '[t]est [A]ll files',
      },
      {
        '<leader>tS',
        function()
          require('neotest').run.run { suite = true }
        end,
        desc = '[t]est [S]uite',
      },
      {
        '<leader>tn',
        function()
          require('neotest').run.run()
        end,
        desc = '[t]est [n]earest',
      },
      {
        '<leader>tl',
        function()
          require('neotest').run.run_last()
        end,
        desc = '[t]est [l]ast',
      },
      {
        '<leader>ts',
        function()
          require('neotest').summary.toggle()
        end,
        desc = '[t]est [s]ummary',
      },
      {
        '<leader>to',
        function()
          require('neotest').output.open { enter = true, auto_close = true }
        end,
        desc = '[t]est [o]utput',
      },
      {
        '<leader>tO',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = '[t]est [O]utput panel',
      },
      {
        '<leader>tt',
        function()
          require('neotest').run.stop()
        end,
        desc = '[t]est [t]erminate',
      },
      {
        '<leader>td',
        function()
          require('neotest').run.run { suite = false, strategy = 'dap' }
        end,
        desc = 'Debug nearest test',
      },
      {
        '<leader>tD',
        function()
          require('neotest').run.run { vim.fn.expand '%', strategy = 'dap' }
        end,
        desc = 'Debug current file',
      },
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-python'(py_config),
          require 'neotest-golang'(go_config),
        },
      }
    end,
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
      'leoluz/nvim-dap-go',
      -- 'mfussenegger/nvim-dap-python',
      'theHamsta/nvim-dap-virtual-text',
    },
    keys = {
      {
        '<leader>B',
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'dap set breakpoint condition',
      },
      {
        '<leader>b',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'dap toggle breakpoint',
      },
      {
        '<leader>dc',
        function()
          require('dap').continue()
        end,
        desc = 'dap continue',
      },
      {
        '<leader>dh',
        function()
          require('dap').step_out()
        end,
        desc = 'dap step out ←',
      },
      {
        '<leader>dl',
        function()
          require('dap').step_into()
        end,
        desc = 'dap step into →',
      },
      {
        '<leader>dk',
        function()
          require('dap').step_back()
        end,
        desc = 'dap step back ↑',
      },
      {
        '<leader>dj',
        function()
          require('dap').step_over()
        end,
        desc = 'dap step over ↓',
      },
      {
        '<leader>de',
        function()
          require('dap').repl.open()
        end,
        desc = 'dap open repl',
      },
      {
        '<leader>dr',
        function()
          require('dap').run_last()
        end,
        desc = 'dap run last',
      },
      {
        '<leader>dq',
        function()
          require('dap').disconnect()
        end,
        desc = 'dap disconnect',
      },
      {
        '<leader>du',
        function()
          require('dapui').toggle()
        end,
        desc = 'toggle dap ui',
      },
      {
        '<leader>do',
        function()
          require('dapui').open()
        end,
        desc = 'toggle dap ui',
      },
      {
        '<leader>dx',
        function()
          require('dapui').close()
        end,
        desc = 'toggle dap ui',
      },
    },
    config = function()
      require('dapui').setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }
      require('nvim-dap-virtual-text').setup {}
      -- require('dap-python').setup()
      require('dap-go').setup {
        dap_configurations = {
          {
            type = 'go',
            name = 'Attach remote',
            mode = 'remote',
            request = 'attach',
          },
        },
        delve = {
          path = 'dlv',
          initialize_timeout_sec = 20,
          port = '${port}',
          args = { '-tag=unit,integration' },
          build_flags = '',
        },
      }

    end,
  },

  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'mason-org/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'leoluz/nvim-dap-go',
    },
    cmd = { 'DapContinue', 'DapToggleBreakpoint', 'DapStepOver', 'DapStepInto', 'DapStepOut', 'DapNew', 'DapTerminate', 'DapToggleRepl', 'DapClearBreakpoints' },
    keys = {
      {
        '<F5>',
        function()
          require('dap').continue()
        end,
        desc = 'Debug: Start/Continue',
      },
      {
        '<F1>',
        function()
          require('dap').step_into()
        end,
        desc = 'Debug: Step Into',
      },
      {
        '<F2>',
        function()
          require('dap').step_over()
        end,
        desc = 'Debug: Step Over',
      },
      {
        '<F3>',
        function()
          require('dap').step_out()
        end,
        desc = 'Debug: Step Out',
      },
      {
        '<F7>',
        function()
          require('dapui').toggle()
        end,
        desc = 'Debug: See last session result.',
      },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'
      require('mason-nvim-dap').setup {
        automatic_setup = true,
        handlers = {},
        ensure_installed = {
          'delve',
        },
      }


      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close
      require('dap-go').setup()
    end,
  },
}
