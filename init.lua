require("config.options")
require("config.keymaps")
require("config.lazy")
require("config.autocmds")
-- require("config.floatwin")
require("lsp.diagnostics")
vim.cmd("colorscheme tokyonight")
-- vim.cmd("colorscheme solarized-osaka")

-- Add this line to your init.lua file
-- vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"

local lsp_dir = vim.fn.stdpath("config") .. "/lua/lsp"
for _, file in ipairs(vim.fn.globpath(lsp_dir, "*.lua", false, true)) do
  local name = vim.fn.fnamemodify(file, ":t:r")
  if name ~= "diagnostics" then
    local config = require("lsp." .. name)
    vim.lsp.config[name] = config
    vim.lsp.enable(name)
  end
end

-- vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
-- vim.api.nvim_set_hl(0, "PmenuSel", { bg = "none", fg = "#ffffff", bold = true })
-- vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#2a2e36" })
-- vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#5c6370" })

-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e222a" })
-- vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#5c6370", bg = "#1e222a" })
