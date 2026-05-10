-- ┌────────────────┐
-- │ LSP Auto-Enable│
-- └────────────────┘
local lsp_files = vim.api.nvim_get_runtime_file('lsp/*.lua', true)
local configs = {}
for _, path in ipairs(lsp_files) do
  table.insert(configs, vim.fn.fnamemodify(path, ':t:r'))
end
if #configs > 0 then
  vim.lsp.enable(configs)
end

local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/nvim-mini/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup()
_G.Config = {}

local gr = vim.api.nvim_create_augroup('custom-config', {})
_G.Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

vim.g.mapleader = " "
require("fzf")
