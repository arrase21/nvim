local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and now or later

now(function()
  add("https://github.com/vague-theme/vague.nvim")
  require("vague").setup({
    colors = {
      bg = "none"
    }
  })
  -- vim.cmd("colorscheme vague")
end)

now(function()
  add("rebelot/kanagawa.nvim")
  require('kanagawa').setup({
    overrides = function(colors)
      local theme = colors.theme
      return {

        NormalFloat = { bg = "none" },
        FloatBorder = { bg = "none" },
        FloatTitle = { bg = "none" },
        NormalDark = { fg = "none", bg = "none" },
        LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        MasonNormal = { bg = "none", fg = "none" },
        -- Lualine = { bg = "none", fg = "none" },
      }
    end,
    transparent = true,
    colors = {
      palette = {},
      theme = {
        all = {
          ui = {
            float = {
              bg = "none",
            },
            bg_gutter = "none"
          }
        }
      }
    },
  })
  vim.cmd("colorscheme kanagawa-wave")
end)

now(function()
  add("folke/tokyonight.nvim")
  require("tokyonight").setup({ transparent = true }) --comentar si se desea transparente

  -- local transparent = true
  -- local bg = "#011628"
  -- local bg_dark = "#011423"
  -- local bg_search = "#0A64AC"
  -- local bg_visual = "#275378"
  -- local fg = "#CBE0F0"
  -- local fg_dark = "#B4D0E9"
  -- local fg_gutter = "#627E97"
  -- local border = "#547998"
  --
  -- require("tokyonight").setup({
  --   -- style = "night",
  --   transparent = transparent,
  --   styles = {
  --     sidebars = transparent and "transparent" or "dark",
  --     floats = transparent and "transparent" or "dark",
  --   },
  --   on_colors = function(colors)
  --     colors.bg = bg
  --     colors.bg_dark = transparent and colors.none or bg_dark
  --     colors.bg_float = transparent and colors.none or bg_dark
  --     colors.bg_popup = bg_dark
  --     colors.bg_search = bg_search
  --     colors.bg_sidebar = transparent and colors.none or bg_dark
  --     colors.bg_statusline = transparent and colors.none or bg_dark
  --     colors.bg_visual = bg_visual
  --     colors.border = border
  --     colors.fg = fg
  --     colors.fg_dark = fg_dark
  --     colors.fg_float = fg
  --     colors.fg_gutter = fg_gutter
  --     colors.fg_sidebar = fg_dark
  --   end,
  -- })
  -- vim.schedule(function()
  -- vim.cmd("colorscheme tokyonight")
  -- end)
end)
