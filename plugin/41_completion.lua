local now_if_args = Config.now_if_args

local capabilities = {
   workspace = {
      fileOperations = {
         didRename = true,
         willRename = true,
      },
   },
}

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
      cmdline = {
         enabled = true,
         completion = {
            list = { selection = { preselect = false } },
            menu = { auto_show = function(ctx) return vim.fn.getcmdtype() == ":" end, },
            ghost_text = { enabled = true }
         },
      },
      sources = { default = { 'lsp', 'snippets', 'buffer', 'path' }, },
   })
end)

vim.lsp.config("*", {
   capabilities = require("blink.cmp").get_lsp_capabilities(capabilities),
})
