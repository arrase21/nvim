local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and now or later

now_if_args(function()
  add("romus204/tree-sitter-manager.nvim")
  require("tree-sitter-manager").setup({
    auto_install = true,
  })
end)

now(function()
  add("rebelot/kanagawa.nvim")
  require('kanagawa').setup({
    transparent = true,
    compile = false,
    colors = {
      palette = {},
      theme = {
        all = {
          ui = {
            float = {
              bg = "none",
            },
            bg_gutter = "none",
          }
        }
      }
    },
    overrides = function(colors)
      local theme = colors.theme
      return {
        NormalFloat  = { bg = "none" },
        FloatBorder  = { bg = "none" },
        FloatTitle   = { bg = "none" },
        StatusLine   = { bg = theme.ui.bg_p1 },
        StatusLineNC = { bg = theme.ui.bg_m1 },
      }
    end,
  })
  vim.cmd("colorscheme kanagawa-wave")
end)
now(function()
  add("https://gitlab.com/motaz-shokry/gruvbox.nvim")
  require("gruvbox").setup({
    highlight_groups = {
      Visual = { reverse = true },
    },
    palette = {
      hard = {
        bg_main = "#1D2021",
      },
    },
  })
  vim.cmd('colorscheme gruvbox-hard')
end)

now(function()
  add("folke/tokyonight.nvim")
  require("tokyonight").setup({ transparent = true }) --comentar si se desea transparente
  -- vim.cmd("colorscheme tokyonight")
end)

-- ┌─────────────────────────┐
-- │           DAP           │
-- └─────────────────────────┘

-- Dap ==================================================================
later(function()
  add({
    source = 'mfussenegger/nvim-dap',
    depends = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'mfussenegger/nvim-dap-python',
      'leoluz/nvim-dap-go'
    }
  })

  local dap, dapui = require("dap"), require("dapui")
  local widgets = require("dap.ui.widgets")

  dapui.setup()
  require("dap-go").setup()

  require("dap-python").setup("~/.local/share/uv/tools/debugpy/bin/python")

  dap.listeners.before.attach.dapui_config = function() dapui.open() end
  dap.listeners.before.launch.dapui_config = function() dapui.open() end
  dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
  dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

  local d_map = {
    b = { dap.toggle_breakpoint, "Toggle Breakpoint" },
    B = { function() dap.set_breakpoint(vim.fn.input("Condition: ")) end, "Conditional Breakpoint" },
    c = { dap.continue, "Continue / Start" },
    C = { dap.run_to_cursor, "Run to Cursor" },
    i = { dap.step_into, "Step Into" },
    o = { dap.step_out, "Step Out" },
    O = { dap.step_over, "Step Over" },
    l = { dap.run_last, "Run Last" },
    t = { dap.terminate, "Terminate" },
    r = { dap.repl.toggle, "Toggle REPL" },
    u = { dapui.toggle, "Toggle DAP UI" },
    h = { widgets.hover, "Hover" },
    p = { widgets.preview, "Preview" },
    f = { function() widgets.centered_float(widgets.frames) end, "Frames" },
    s = { function() widgets.centered_float(widgets.scopes) end, "Scopes" },
  }
  for suffix, conf in pairs(d_map) do
    vim.keymap.set("n", "<leader>d" .. suffix, conf[1], { desc = "DAP: " .. conf[2] })
  end
  vim.fn.sign_define("DapBreakpoint", { text = "󰃤 ", texthl = "DapBreakpoint" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "󱌢 ", texthl = "DapBreakpointCondition" })
  vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped" })
end)

-- Kulala =========================================================================================================================================
later(function()
  add("mistweaverco/kulala.nvim")
  require("kulala").setup()
  vim.api.nvim_set_hl(0, "MiniCursorword", { link = "Visual" })
end)

later(function()
  add("nvim-tree/nvim-tree.lua")
  require("nvim-tree").setup({
    actions = {
      open_file = {
        quit_on_open = true,
      },
    },
    diagnostics = {
      enable = true,
      icons = {
        error = "💀",
      }
    },
  })
end)
