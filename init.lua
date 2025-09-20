require("config.options")
require("config.keymaps")
require("config.lazy")
require("config.autocmds")
require("lsp.diagnostics")
vim.cmd("colorscheme tokyonight")

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
