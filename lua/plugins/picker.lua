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
      require('mini.tabline').setup()
      -- require('mini.git').setup()
      -- require('mini.completion').setup()
    end,
  },
}
