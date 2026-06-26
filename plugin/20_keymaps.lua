local function lazygit()
  local w, h = math.floor(vim.o.columns * 0.9), math.floor(vim.o.lines * 0.9)
  local buf  = vim.api.nvim_create_buf(false, true)
  local win  = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    width = w,
    height = h,
    col = math.floor((vim.o.columns - w) / 2),
    row = math.floor((vim.o.lines - h) / 2),
  })
  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end
  vim.fn.termopen("lazygit", { on_exit = close })
  vim.keymap.set("n", "q", close, { buffer = buf })
  vim.cmd.startinsert()
end

local function inlay_hint()
  local buf = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
  vim.notify(
    vim.lsp.inlay_hint.is_enabled({ bufnr = buf }) and "Inlay hints: ON" or "Inlay hints: OFF",
    vim.log.levels.INFO
  )
end

-- ┌─────────────────┐
-- │ Custom mappings │
-- └─────────────────┘
local nmap = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

nmap('K', vim.lsp.buf.hover, 'Hover documentation')
nmap('[p', '<Cmd>exe "iput! " . v:register<CR>', 'Paste Above')
nmap(']p', '<Cmd>exe "iput "  . v:register<CR>', 'Paste Below')

-- Leader mappings ============================================================
Config.leader_group_clues = {
  { mode = 'n', keys = '<Leader>b', desc = '󰓩  Buffers' },
  { mode = 'n', keys = '<Leader>d', desc = '  Debug' },
  { mode = 'n', keys = '<Leader>f', desc = '󰱼 Find' },
  { mode = 'n', keys = '<Leader>e', desc = ' Explore/Edit' },
  { mode = 'n', keys = '<Leader>g', desc = '󰘬 Git' },
  { mode = 'n', keys = '<Leader>h', desc = '󰚩 Harpoon' },
  { mode = 'n', keys = '<Leader>r', desc = '󰗼  kulala/rest' },
  { mode = 'n', keys = '<Leader>l', desc = ' Language' },
  { mode = 'n', keys = '<Leader>o', desc = '󰚩 Other' },
  { mode = 'n', keys = '<Leader>q', desc = '󰗼  Quit/Session' },
  { mode = 'n', keys = '<Leader>s', desc = '+Session' },
  { mode = 'x', keys = '<Leader>g', desc = '+Git' },
  { mode = 'x', keys = '<Leader>l', desc = '+Language' },
}

local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end
local nmap_leader = function(suffix, rhs, desc) map('n', '<Leader>' .. suffix, rhs, desc) end
local xmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('x', '<Leader>' .. suffix, rhs, { desc = desc })
end
nmap_leader('bd', '<cmd>bwipeout<cr>', 'Delete')

local explore_at_file = '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>'
local explore_quickfix = function()
  vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and 'cclose' or 'copen')
end
local explore_locations = function()
  vim.cmd(vim.fn.getloclist(0, { winid = true }).winid ~= 0 and 'lclose' or 'lopen')
end

nmap_leader('ed', '<Cmd>lua MiniFiles.open()<CR>', 'Directory')
nmap_leader('ef', explore_at_file, 'File directory')
nmap_leader('en', '<Cmd>lua MiniNotify.show_history()<CR>', 'Notifications')
nmap_leader('eq', explore_quickfix, 'Quickfix list')
nmap_leader('eQ', explore_locations, 'Location list')
nmap_leader('et', '<Cmd>NvimTreeOpen()<CR>', 'NerdTree')

nmap_leader('fb', '<Cmd>FzfBuffers<CR>', 'Buffers')
nmap_leader('fd', '<Cmd>FzfLspDiagnostics<CR>', 'Diagnostics')
nmap_leader('fD', '<Cmd>FzfLspDefinitions<CR>', 'Definitions')
nmap_leader('ff', '<Cmd>FzfFiles<CR>', 'Files')
nmap_leader('fo', '<Cmd>FzfOldFiles<CR>', 'Old Files')
nmap_leader('fg', '<Cmd>FzfGrep<CR>', 'Grep')
nmap_leader('fG', '<Cmd>FzfGrepW<CR>', 'Grep current word')
nmap_leader('fr', '<Cmd>FzfLspReferences<CR>', 'References (LSP)')
nmap_leader('fs', '<Cmd>FzfLspSymbols<CR>', 'Symbols')

nmap_leader('gg', lazygit, 'Lazygit')
nmap_leader('gC', '<Cmd>Git commit --amend<CR>', 'Commit amend')

local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_log_buf_cmd = git_log_cmd .. ' --follow -- %'
nmap_leader('ga', '<Cmd>Git diff --cached<CR>', 'Added diff')
nmap_leader('gc', '<Cmd>Git commit<CR>', 'Commit')
nmap_leader('gA', '<Cmd>Git diff --cached -- %<CR>', 'Added diff buffer')
nmap_leader('gb', '<Cmd>FzfGitBranches<CR>', 'Git Branch')
nmap_leader('gl', '<Cmd>FzfGitCommits<CR>', 'Git Commits')
nmap_leader('gs', '<Cmd>FzfGitStatus<CR>', 'Git Status')
nmap_leader('gd', '<Cmd>FzfGitDiff<CR>', 'Diff')
nmap_leader('gD', '<Cmd>Git diff<CR>', 'Diff')
-- nmap_leader('gD', '<Cmd>Git diff -- %<CR>', 'Diff buffer')
nmap_leader('gL', '<Cmd>' .. git_log_buf_cmd .. '<CR>', 'Log buffer')

nmap_leader('la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', 'Actions')
nmap_leader('ld', function() vim.diagnostic.jump({ count = 1, float = true }) end, 'Next Diagnostic')
nmap_leader('lD', function() vim.diagnostic.jump({ count = -1, float = true }) end, 'Prev Diagnostic')
nmap_leader('lf', '<Cmd>lua require("conform").format()<CR>', 'Format')
nmap_leader('li', '<Cmd>lua vim.lsp.buf.implementation()<CR>', 'Implementation')
nmap_leader('lh', '<Cmd>lua vim.lsp.buf.hover()<CR>', 'Hover')
nmap_leader('ll', '<Cmd>lua vim.lsp.codelens.run()<CR>', 'Lens')
nmap_leader('lr', '<Cmd>lua vim.lsp.buf.rename()<CR>', 'Rename')
nmap_leader('lR', '<Cmd>lua vim.lsp.buf.references()<CR>', 'References')
nmap_leader('ls', '<Cmd>lua vim.lsp.buf.definition()<CR>', 'Source definition')
nmap_leader('lt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', 'Type definition')
xmap_leader('lf', '<Cmd>lua require("conform").format()<CR>', 'Format selection')

-- o is for 'Other'. Common usage:
nmap_leader("oa", "gg<S-v>G", 'select all')
nmap_leader('oh', inlay_hint, 'Inlay')
nmap_leader('or', '<Cmd>lua MiniMisc.resize_window()<CR>', 'Resize to default width')
nmap_leader("os", ":split<Return>", 'split')
nmap_leader('ot', '<Cmd>lua MiniTrailspace.trim()<CR>', 'Trim trailspace')
nmap_leader("ov", ":vsplit<Return>", 'split vertical')
nmap_leader("oy", "mzyyp`zj", "copy/paste")
nmap_leader('oz', '<Cmd>lua MiniMisc.zoom()<CR>', 'Zoom toggle')

nmap_leader('sl', '<Cmd>FzfSessionLoad<CR>', 'Read')
nmap_leader('sd', '<Cmd>FzfSessionDelete<CR>', 'Delete')
nmap_leader('sv', '<Cmd>FzfSessionSave<CR>', 'Save')

nmap_leader('hh', '<Cmd>FzfHarpoon<CR>', 'Read')
nmap_leader('ha', '<Cmd>FzfHarpoonAdd<CR>', 'add')
nmap_leader('hd', '<Cmd>FzfHarpoonRemove<CR>', 'Delete')

-- 4. Globales ================================================================
-- Navegación entre ventanas
map('n', '<C-h>', '<C-w>h', 'Window Left')
map('n', '<C-j>', '<C-w>j', 'Window Down')
map('n', '<C-k>', '<C-w>k', 'Window Up')
map('n', '<C-l>', '<C-w>l', 'Window Right')

-- Mover líneas
map("n", "<A-j>", ":m .+1<CR>==", 'Move line down')
map("n", "<A-k>", ":m .-2<CR>==", 'Move line up')

-- Escape en insert mode
map('i', 'kj', '<ESC>', 'Escape')
map('i', 'KJ', '<ESC>', 'Escape')

-- Quit / Write
map("n", "<leader>qq", "<cmd>qa<cr>", "Quit All")
map("n", "<leader>qa", "<cmd>q<cr>", "Quit")
map('n', '<leader>w', '<Cmd>w<CR>', 'Write')

-- Misc
map('n', '<backspace>', 'diw', 'Delete word')

-- Resize ventanas
map("n", "<C-A-k>", "<cmd>resize +2<cr>", "Increase Window Height")
map("n", "<C-A-j>", "<cmd>resize -2<cr>", "Decrease Window Height")
map("n", "<C-A-L>", "<cmd>vertical resize -2<cr>", "Decrease Window Width")
map("n", "<C-A-h>", "<cmd>vertical resize +2<cr>", "Increase Window Width")

nmap_leader('rs', function() require('kulala').run() end, 'Send request')
-- stylua: ignore end


vim.keymap.set("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true, noremap = true })

vim.keymap.set("i", "<S-Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true, noremap = true })

-- Confirmar con Enter
vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-y>"
  end
  return "<CR>"
end, { expr = true, noremap = true })
