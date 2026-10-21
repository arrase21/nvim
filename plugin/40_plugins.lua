local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and now or later

--Treesitter
now_if_args(function()
  add("romus204/tree-sitter-manager.nvim")
  require("tree-sitter-manager").setup({
    auto_install = true,
  })
end)

now(function()
  add("arrase21/fzfnvim")
  require("fzf").setup({
    ui = {
      layout = "horizontal", -- vertical, fullscreen, center, horizontal
      horizontal = {
        width = 1.0,
        height = 0.50,
        border = "rounded",
      },
      -- preview = {
      --   position = "top",         -- "right" | "left" | "top" | "bottom"
      --   border = "border-bottom", -- estilo borde del preview
      -- },
    },
  })
end)

now(function()
  add('arrase21/fyler.nvim')
  require("fyler").setup({
    integrations = {
      icon = "mini_icons"
    },
    extensions = {
      git = { enabled = true, inline = false },
      trash = { enabled = true },
      watcher = { enabled = true }
    },
    ui = {
      hidden_items = {
        always_visible = { ".git" },
      }
    },
    kind_presets = {
      split_left_most = {
        mappings = {
          n = {
            ['<CR>'] = { action = 'select', args = { close = true, pick = false } },
          },
        },
      },
    },
  })
end)

-- dap======================================================================
later(function()
  add({
    source = 'mfussenegger/nvim-dap',
    depends = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'mfussenegger/nvim-dap-python',
      'leoluz/nvim-dap-go',
      'mfussenegger/nvim-jdtls',
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

later(function()
  add("mistweaverco/kulala.nvim")
  require("kulala").setup()
  vim.api.nvim_set_hl(0, "MiniCursorword", { link = "Visual" })
end)

now(function()
  add({
    source = "saghen/blink.cmp",
    depends = { "saghen/blink.lib" },
  })

  require("blink.cmp").setup({
    keymap = {
      preset = "enter",
      ["<Tab>"] = {
        "select_next",
        "snippet_forward",
        "fallback",
      },
    },
    completion = {
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 50,
      },
    },
    sources = {
      default = { "lsp", "path", "buffer" },
    },
  })
end)
