-- stylua: ignore start
-- General ====================================================================
vim.g.mapleader     = ' '            -- Use <Space> as a leader key
vim.o.mouse         = 'a'            -- Enable mouse
vim.o.mousescroll   = 'ver:25,hor:6' -- Customize mouse scroll
vim.o.switchbuf     = 'usetab'       -- Use already opened buffers when switching
vim.o.undofile      = true           -- Enable persistent undo
vim.o.encoding      = 'utf-8'
vim.o.fileencoding  = 'utf-8'
vim.o.shada         = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file
-- Clipboard
vim.o.clipboard     = vim.env.SSH_TTY and '' or 'unnamedplus'

vim.o.linebreak     = true
vim.o.list          = false
-- vim.o.number          = true
-- vim.o.relativenumber  = true
vim.o.cursorline    = true
-- vim.o.pumborder     = 'rounded' -- Use border in popup menu
-- vim.o.winborder     = 'rounded'
vim.o.cursorlineopt = 'screenline,number'
vim.o.signcolumn    = 'yes'

-- Folds
vim.o.foldlevel     = 1      -- Fold nothing by default
vim.o.foldmethod    = 'expr' -- Fold based on indent
vim.o.foldnestmax   = 10     -- Max fold levels
vim.o.foldtext      = ''     -- Use default fold text
vim.o.foldexpr      = 'v:lua.vim.treesitter.foldexpr()'


vim.o.autoindent      = true
vim.o.expandtab       = true
vim.o.formatoptions   = 'jqln'
vim.o.ignorecase      = true
vim.o.incsearch       = true
vim.o.shiftwidth      = 3
vim.o.smartcase       = true
vim.o.smartindent     = true
vim.o.tabstop         = 3
vim.o.smarttab        = true
vim.o.completeopt     = 'menuone,noinsert'
vim.o.complete        = '.,w,b,kspell'
vim.o.completetimeout = 100 -- Limit sources delay
vim.o.confirm         = true
vim.o.updatetime      = 200
vim.o.backup          = false
vim.o.showcmd         = true
vim.o.showmode        = false

-- Diagnostics ================================================================
local diagnostic_opts = {
   underline = true,
   update_in_insert = false,
   virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "",
      format = function(diagnostic)
         return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
      end,
   },
   severity_sort = true,
   signs = {
      text = {
         [vim.diagnostic.severity.ERROR] = "",
         [vim.diagnostic.severity.WARN]  = "",
         [vim.diagnostic.severity.HINT]  = "󰌵",
         [vim.diagnostic.severity.INFO]  = "",
      },
   },
}

Config.later(function() vim.diagnostic.config(diagnostic_opts) end)
