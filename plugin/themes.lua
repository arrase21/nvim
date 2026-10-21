local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and now or later

later(function()
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
