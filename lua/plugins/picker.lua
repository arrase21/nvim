-- Diccionario de iconos por "kind"
local kind_icons = {
  Text = "",
  Method = "",
  Function = "󰡱",
  Constructor = "",
  Field = "",
  Variable = "󰀫",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

-- Reemplazar "kind" en los items de completado
vim.lsp.protocol.CompletionItemKind = vim.tbl_map(function(kind)
  return kind_icons[kind] or kind
end, vim.lsp.protocol.CompletionItemKind)

-- Highlights básicos para el menú de completado
vim.cmd([[
  highlight! CmpItemKindFunction guifg=#A3BE8C
  highlight! CmpItemKindVariable guifg=#EBCB8B
  highlight! CmpItemKindClass guifg=#81A1C1
  highlight! CmpItemKindKeyword guifg=#B48EAD
  highlight! CmpItemAbbrMatch guifg=#88C0D0 gui=bold
  highlight! CmpItemAbbrDeprecated guifg=#BF616A gui=strikethrough
]])

return {
  {
    "nvim-mini/mini.nvim",
    version = false, -- para siempre usar la última versión
    config = function()
      require("mini.pick").setup({})
      require("mini.files").setup({
        mappings = {
          go_in_plus = "<CR>",       -- Entrar y abrir en ventana reciente
          synchronize = "<Leader>w", -- Remapear sincronización a <Leader>w
        },

      })
      require('mini.icons').setup()
      require('mini.pairs').setup()
      -- require('mini.tabline').setup()
      require('mini.git').setup()
      require('mini.diff').setup({
        view = {
          style = "sign",
          signs = { add = '▒', change = '▒', delete = '消' },
        }
      })
      require('mini.completion').setup()
    end,
  },
}
