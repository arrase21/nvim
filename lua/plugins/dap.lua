return {
  -- nvim-dap main plugin
  { "nvim-neotest/nvim-nio" },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      -- Python configuration
      dap.adapters.python = {
        type = "executable",
        command = os.getenv("HOME") .. "/.virtualenvs/debugpy/bin/python",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return "/usr/bin/python3"
          end,
        },
      }

      -- C# configuration
      dap.adapters.coreclr = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
        },
      }
    end,
  },

  -- nvim-dap UI plugin
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      icons = { expanded = "▾", collapsed = "▸" },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      sidebar = {
        -- You can change the order of elements in the sidebar
        elements = {
          -- Provide IDs as strings or tables with "id" and "size" keys
          {
            id = "scopes",
            size = 0.25, -- Can be float or integer > 1
          },
          { id = "breakpoints", size = 0.25 },
          { id = "stacks", size = 0.25 },
          { id = "watches", size = 00.25 },
        },
        size = 40,
        position = "left", -- Can be "left" or "right"
      },
      tray = {
        elements = { "repl" },
        size = 10,
        position = "bottom", -- Can be "bottom" or "top"
      },
    },
    config = function(_, opts)
      local dapui = require("dapui")
      dapui.setup(opts)
      vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "🚫", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "➡️", texthl = "", linehl = "DebugBreakpointLine", numhl = "" })

      -- Automatically open UI when starting debug session
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- Python DAP extension
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function(_, opts)
      local dap_python = require("dap-python")
      dap_python.setup("~/.virtualenvs/debugpy/bin/python")
    end,
  },

  -- C# DAP extension
  {
    "OmniSharp/omnisharp-vscode",
    ft = "cs",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function(_, opts)
      local dap = require("dap")
      dap.adapters.coreclr = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
        },
      }
    end,
  },
}

-- return {
--
-- 	"mfussenegger/nvim-dap",
-- 	dependencies = {
-- 		"rcarriga/nvim-dap-ui",
-- 		"rcarriga/cmp-dap",
-- 		"ravenxrz/DAPInstall.nvim",
-- 		"mfussenegger/nvim-dap-python",
-- 	},
-- 	keys = { { "<leader>d", desc = "Open Debug menu" } },
-- 	config = function()
-- 		require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
-- 		table.insert(require("dap").configurations.python, {
-- 			type = "python",
-- 			request = "launch",
-- 			name = "My custom launch configuration",
-- 			program = "${file}",
-- 		})
-- 		vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
-- 		vim.fn.sign_define("DapBreakpointRejected", { text = "🚫", texthl = "", linehl = "", numhl = "" })
-- 		vim.fn.sign_define("DapStopped", { text = "➡️", texthl = "", linehl = "DebugBreakpointLine", numhl = "" })
--
-- 		require("dapui").setup({
-- 			icons = { expanded = "▾", collapsed = "▸" },
-- 			mappings = {
-- 				expand = { "<CR>", "<2-LeftMouse>" },
-- 				open = "o",
-- 				remove = "d",
-- 				edit = "e",
-- 				repl = "r",
-- 				toggle = "t",
-- 			},
-- 			expand_lines = vim.fn.has("nvim-0.7"),
--
-- 			layouts = {
-- 				{
-- 					elements = {
-- 						"scopes",
-- 						"breakpoints",
-- 						"stacks",
-- 						"watches",
-- 					},
-- 					size = 40,
-- 					position = "left",
-- 				},
-- 				{
-- 					elements = {
-- 						"repl",
-- 						"console",
-- 					},
-- 					size = 10,
-- 					position = "bottom",
-- 				},
-- 			},
-- 			floating = {
-- 				max_height = nil, -- These can be integers or a float between 0 and 1.
-- 				max_width = nil, -- Floats will be treated as percentage of your screen.
-- 				border = "single", -- Border style. Can be "single", "double" or "rounded"
-- 				mappings = {
-- 					close = { "q", "<Esc>" },
-- 				},
-- 			},
-- 			windows = { indent = 1 },
-- 			render = {
-- 				max_type_length = nil, -- Can be integer or nil.
-- 			},
-- 		})
--
-- 		local dap, dapui = require("dap"), require("dapui")
-- 		dap.listeners.after.event_initialized["dapui_config"] = function()
-- 			dapui.open()
-- 		end
-- 		dap.listeners.before.event_terminated["dapui_config"] = function()
-- 			dapui.close()
-- 		end
-- 		dap.listeners.before.event_exited["dapui_config"] = function()
-- 			dapui.close()
-- 		end
-- 	end,
-- }
