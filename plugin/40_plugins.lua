local now_if_args, later = Config.now_if_args, Config.later

-- TreeSitter
now_if_args(function()
   require("tree-sitter-manager").setup({
      auto_install = true,
   })
end)

-- Explorer
now_if_args(function()
   require("fzf").setup({
      ui = {
         layout = "vertical", -- vertical, fullscreen, center, horizontal
         -- vertical = {
         --   width = 0.85,
         --   height = 0.65,
         --   border = "rounded",
         -- },
         preview = {
            position = "top",         -- "right" | "left" | "top" | "bottom"
            size = "70",
            border = "border-bottom", -- estilo borde del preview
         },
      },
   })
end)

now_if_args(function()
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
         hidden_items = { always_visible = { ".git" }, }
      },
      kind_presets = {
         split_left_most = {
            mappings = {
               n = {
                  ['<CR>'] = { action = 'select', args = { close = true, pick = true } },
               },
            },
         },
      },
   })
end)

-- Dap

later(function()
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
   require("kulala").setup()
   vim.api.nvim_set_hl(0, "MiniCursorword", { link = "Visual" })
end)


now_if_args(function()
   require("blink.cmp").setup({
      fuzzy = { implementation = 'prefer_rust' },
      signature = { enabled = true },
      appearance = {
         use_nvim_cmp_as_default = true,
         nerd_font_variant = "normal",
      },
      keymap = {
         preset = "enter",
         ["<Tab>"] = {
            "select_next",
            "snippet_forward",
            "fallback",
         },
      },
      completion = {
         list = { selection = { preselect = true, auto_insert = false, }, },
         documentation = { auto_show = true, auto_show_delay_ms = 50, },
         menu = {
            draw = {
               columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name' } },
            },
         },
         ghost_text = {
            enabled = true,
         },
      },
      sources = {
         default = { 'lsp', 'snippets', 'buffer', 'path' },
      },
   })
end)
