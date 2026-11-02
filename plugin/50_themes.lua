local now_if_args, later = Config.now_if_args, Config.later

now_if_args(function()
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
   })
   -- vim.cmd("colorscheme kanagawa-wave")
end)

now_if_args(function()
   vim.g.gruvbox_contrast_dark = "hard"
   vim.o.background = "dark"
   vim.cmd('colorscheme gruvbox')
   vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
end)

now_if_args(function()
   require("dracula").setup({
      -- transparent_bg = true
   })
   -- vim.cmd('colorscheme dracula')
end)

now_if_args(function()
   require("base46").setup({
      transparency = true
   })
   vim.cmd.colorscheme("base46-gruvbox")
end)
