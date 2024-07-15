-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"

-- Tab
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true

-- Search Setting
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

-- Term
opt.termguicolors = true
opt.signcolumn = "yes"
opt.background = "dark"

-- Copy
opt.clipboard = "unnamedplus"

opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.showmode = false -- Dont show mode since we have a statusline

-- Time Complete
opt.timeoutlen = 300
opt.updatetime = 200

opt.foldmethod = "manual"
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  -- fold = "⸱",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
  stlnc = "—",
}
-- UnderCurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

vim.cmd("set confirm")
