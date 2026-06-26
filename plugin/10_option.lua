-- stylua: ignore start
-- General ====================================================================
vim.g.mapleader      = ' '            -- Use <Space> as a leader key
vim.o.mouse          = 'a'            -- Enable mouse
vim.o.mousescroll    = 'ver:25,hor:6' -- Customize mouse scroll
vim.o.switchbuf      = 'usetab'       -- Use already opened buffers when switching
vim.o.undofile       = true           -- Enable persistent undo
vim.o.encoding       = 'utf-8'
vim.o.fileencoding   = 'utf-8'
vim.o.shada          = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file
-- Clipboard
vim.o.clipboard      = vim.env.SSH_TTY and '' or 'unnamedplus'

vim.o.linebreak      = true
vim.o.list           = false
vim.o.number         = true
vim.o.relativenumber = true
vim.o.cursorline     = true
vim.o.cursorlineopt  = 'screenline,number'
vim.o.signcolumn     = 'number'
vim.o.laststatus     = 3

-- Folds
vim.o.foldlevel      = 1        -- Fold nothing by default
vim.o.foldmethod     = 'indent' -- Fold based on indent
vim.o.foldnestmax    = 10       -- Max fold levels
vim.o.foldtext       = ''       -- Use default fold text

-- Editing ====================================================================
vim.o.autoindent     = true
vim.o.expandtab      = true
vim.o.formatoptions  = 'jqln'
vim.o.ignorecase     = true
vim.o.incsearch      = true
vim.o.shiftwidth     = 2
vim.o.smartcase      = true
vim.o.smartindent    = true
vim.o.tabstop        = 2
vim.o.smarttab       = true
vim.o.completeopt    = 'menuone,noinsert'
vim.o.complete       = '.,w,b,kspell'
vim.o.confirm        = true
vim.o.updatetime     = 200
vim.o.backup         = false
vim.o.showcmd        = true


-- Diagnostics ================================================================
local diagnostic_opts = {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = "󰌵 ",
      [vim.diagnostic.severity.INFO]  = " ",

    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
  float = {
    source = "always",
    header = "",
    focusable = false,
  },
  -- virtual_text = true,
  virtual_text = {
    current_line = true,
    spacing = 2,
    prefix = "",
    source = false,
  },
  current_line = true,
  underline = { severity = { min = 'HINT', max = 'ERROR' } },
  update_in_insert = false,
}
MiniDeps.later(function() vim.diagnostic.config(diagnostic_opts) end)
