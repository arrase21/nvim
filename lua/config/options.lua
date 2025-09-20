vim.g.mapleader = " "
--
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.winborder = "rounded"
-- LazyVim auto format
vim.g.autoformat = true
-- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = true
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.conceallevel = 2                                    -- Hide * markup for bold and italic, but not markers with substitutions
vim.opt.confirm = true                                      -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true                                   -- Enable highlighting of the current line
vim.opt.expandtab = true
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.opt.foldlevel = 99
vim.opt.foldmethod = "indent"
vim.opt.foldtext = ""
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.inccommand = "nosplit"
vim.opt.jumpoptions = "view"
vim.opt.laststatus = 3

vim.opt.linebreak = true -- Wrap lines at convenient points
vim.opt.list = true      -- Show some invisible characters (tabs...
vim.opt.mouse = "a"      -- Enable mouse mode
vim.opt.pumblend = 20    -- Popup blend
vim.opt.pumheight = 20   -- Maximum number of entries in a popup
vim.opt.ruler = false    -- Disable the default ruler
vim.opt.scrolloff = 10
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 2
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.smartcase = true   -- Don't ignore case with capitals
vim.opt.smartindent = true
vim.opt.smoothscroll = true

vim.opt.spelllang = { "en" }
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitkeep = "screen"
vim.opt.splitright = true -- Put new windows right of current
vim.opt.tabstop = 2
vim.opt.smarttab = true

vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200               -- Save swap file and trigger CursorHold
vim.opt.virtualedit = "block"          -- Allow cursor to move where there is no text in visual block mode
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5                -- Minimum window width
vim.opt.wrap = false                   -- Disable line wrap

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.shell = "fish"
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.breakindent = true
vim.opt.wrap = false          -- No Wrap lines
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*" })

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments

vim.cmd([[au BufNewFile,BufRead *.astro setf astro]])
vim.cmd([[au BufNewFile,BufRead Podfile setf ruby]])

if vim.fn.has("nvim-0.8") == 1 then
  vim.opt.cmdheight = 0
end

-- File types
vim.filetype.add({
  extension = {
    mdx = "mdx",
  },
})
