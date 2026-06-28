local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and now or later

now_if_args(function()
  add("romus204/tree-sitter-manager.nvim")
  require("tree-sitter-manager").setup({
    auto_install = true,
  })
end)

later(function()
  add("rebelot/kanagawa.nvim")
  require('kanagawa').setup({
    -- transparent = true,
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
  })
  -- vim.cmd("colorscheme kanagawa-wave")
end)
now(function()
  add("arrase21/gruvbox")
  vim.g.gruvbox_contrast_dark = "hard"
  vim.o.background = "dark"
  vim.cmd('colorscheme gruvbox')
end)
--Dracula
now_if_args(function()
  add("arrase21/dracula.nvim")
  require("dracula").setup({
    -- transparent_bg = true
  })
  -- vim.cmd('colorscheme dracula')
end)
later(function()
  add("mistweaverco/kulala.nvim")
  require("kulala").setup()
  vim.api.nvim_set_hl(0, "MiniCursorword", { link = "Visual" })
end)
--Treesitter
later(function()
  add("nvim-tree/nvim-tree.lua")
  require("nvim-tree").setup({
    diagnostics = {
      enable = true,
      icons = {
        error = "",
      }
    },
    actions = {
      open_file = {
        quit_on_open = true,
      },
    },
    renderer = {
      icons = {
        show = {
          hidden = true
        },
        git_placement = "after",
        symlink_arrow = " -> ",
        glyphs = {
          folder = {
            arrow_closed = " ",
            arrow_open = " ",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = ""
          },
          default = "󱓻",
          symlink = "󱓻",
          bookmark = "",
          modified = "",
          hidden = "󱙝",
          git = {
            unstaged = "×",
            staged = "",
            unmerged = "󰧾",
            untracked = "",
            renamed = "",
            deleted = "",
            ignored = "∅"
          }
        }
      }
    },
    filters = {
      git_ignored = false
    },
    hijack_cursor = true,
    sync_root_with_cwd = true
  })
end)

later(function()
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

-- Dap ==================================================================
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
