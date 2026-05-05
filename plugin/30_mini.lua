local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add({ name = 'mini.nvim', checkout = 'HEAD' })


now(function()
  require('mini.icons').setup({
    filetype = { go = { glyph = "" } },
  })
  later(MiniIcons.mock_nvim_web_devicons)
  later(MiniIcons.tweak_lsp_kind)
end)

now(function() require('mini.notify').setup({ content = { sort = custom_sort } }) end)

now(function() require('mini.starter').setup() end)

now(function() require('mini.tabline').setup() end)

-- Step two ===================================================================
later(function() require('mini.extra').setup() end)

later(function()
  local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
  end
  require('mini.completion').setup({
    lsp_completion = { source_func = 'omnifunc', auto_setup = false, process_items = process_items },
  })
  local on_attach = function(args) vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end
  _G.Config.new_autocmd('LspAttach', '*', on_attach, 'Custom `on_attach`')
  if vim.fn.has('nvim-0.11') == 1 then vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() }) end
end)

later(function()
  require('mini.diff').setup({
    view = {
      style = "sign",
      signs = { add = '▒', change = '▒', delete = '消' },
    }
  })
end)

later(function()
  require('mini.files').setup({
    windows = {
      preview = true
    },
    mappings = {
      go_in_plus = "<CR>",
      synchronize = "<Leader>w",
    },
  })
end)

later(function() require('mini.git').setup() end)

later(function() require('mini.indentscope').setup() end)

later(function() require('mini.pairs').setup({ modes = { insert = true, command = true, terminal = false } }) end)

later(function() require('mini.pick').setup() end)

later(function() require('mini.surround').setup() end)

later(function() require('mini.visits').setup() end)

now(function() require('mini.sessions').setup() end)

-- now(function() require('mini.cursorword').setup() end)

now(function()
  local miniclue = require('mini.clue')
  miniclue.setup({
    window = {
      delay = 100,
    },
    clues = {
      Config.leader_group_clues,
      miniclue.gen_clues.g(),
      miniclue.gen_clues.registers(),
    },
    triggers = {
      { mode = 'n', keys = '<Leader>' }, -- Leader triggers
      { mode = 'n', keys = 'g' },        -- `g` key
    },
  })
end)

-- Mini Starter ====================================================================================================
Mvim_starter_custom = function()
  return {
    { name = "Quit Neovim", action = "qa",                                                    section = "", },
    { name = "Old Files",   action = function() require("mini.extra").pickers.oldfiles() end, section = "" },
  }
end
require("mini.starter").setup({
  autoopen = true,
  items = {
    Mvim_starter_custom(),
    require("mini.starter").sections.recent_files(4, false, false),
    require("mini.starter").sections.sessions(4, false, false),
    -- require("mini.starter").sections.quit(3, false, false),
  },
  header = function()
    local image = [[
    ┌─────────────────────────────────────────────────────┐
    │                                                     │
    │    █████╗ ██████╗ ██████╗  █████╗ ███████╗███████╗  │
    │   ██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝  │
    │   ███████║██████╔╝██████╔╝███████║███████╗█████╗    │
    │   ██╔══██║██╔══██╗██╔══██╗██╔══██║╚════██║██╔══╝    │
    │   ██║  ██║██║  ██║██║  ██║██║  ██║███████║███████╗  │
    │   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝  │
    │                       ARRASE                        │
    └─────────────────────────────────────────────────────┘
    ]]
    return image
  end,
  footer = "",
  query_updater = false,
})


-- Mini Statusline ================================================================================================
local function set_hl()
  for name, opts in pairs({
    SLSepGreen  = { fg = '#50FA7B', bg = 'none' },
    SLCapsGreen = { fg = '#282c34', bg = '#50FA7B', bold = true },
    SLInfo      = { fg = '#50FA7B', bg = '#2D2D4E', bold = true },
    SLCaps      = { fg = '#282c34', bg = '#ec5f67', bold = true },
    SLFile      = { fg = 'none', bg = '#2D2D4E', bold = true },
    SLMid       = { fg = '#bbc2cf', bg = '#9A86FD' },
    Err         = { fg = '#ec5f67', bg = 'none' },
    Warn        = { fg = '#ECBE7B', bg = 'none' },
    Info        = { fg = '#008080', bg = 'none' },
    Hint        = { fg = '#05C3FF', bg = 'none' },
    SLGitBranch = { fg = '#bbc2cf', bg = 'none', bold = true },
  }) do
    vim.api.nvim_set_hl(0, name, opts)
  end
end
set_hl()
vim.api.nvim_create_autocmd('ColorScheme', { callback = set_hl })

local function sep(icon, hl_from, hl_to)
  local fg = vim.api.nvim_get_hl(0, { name = hl_from }).bg
  local bg = vim.api.nvim_get_hl(0, { name = hl_to }).bg
  local name = 'SLSep_' .. hl_from .. '_' .. hl_to
  vim.api.nvim_set_hl(0, name, { fg = fg or 'NONE', bg = bg or 'NONE' })
  return '%#' .. name .. '#' .. icon
end

local function lsp_info()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local ignore = { ['mini.snippets'] = true }
  clients = vim.tbl_filter(function(c) return not ignore[c.name] end, clients)
  if #clients == 0 then return 'No LSP' end
  return table.concat(vim.tbl_map(function(c) return c.name end, clients), ', ')
end

local function diag()
  local counts = vim.diagnostic.count(0)
  if not next(counts) then return '' end
  local p = {}
  if counts[1] then table.insert(p, '%#Err#  ' .. counts[1]) end
  if counts[2] then table.insert(p, '%#Warn# ' .. counts[2]) end
  if counts[3] then table.insert(p, '%#Info# ' .. counts[3]) end
  if counts[4] then table.insert(p, '%#Hint#󰌵 ' .. counts[4]) end
  return table.concat(p, ' ') .. '%#SLMid#'
end

require('mini.statusline').setup({
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local git           = MiniStatusline.section_git({ trunc_width = 75, icon = ' ' })
      local diff          = MiniStatusline.section_diff({ trunc_width = 75, icon = '' })
      local ficon         = require('mini.icons').get('file', vim.fn.expand('%:t'))
      local vicon         = require('mini.icons').get('filetype', 'vim')
      local user          = os.getenv("USER") or "User"
      local d             = diag()
      local diff_colored  = diff:gsub('%+(%d+)', ' %1'):gsub('~(%d+)', '󰝤 %1'):gsub('%-(%d+)', ' %1')
      local left          =
          '%#' .. mode_hl .. '# ' .. vicon .. ' ' .. mode .. ' '
          .. sep('', mode_hl, 'SLMid')
          .. sep('', 'SLMid', 'SLFile')
          .. ' %#SLFile#' .. ficon .. '%#SLFile# %t%m '
          .. sep('', 'SLFile', '')
          .. (git ~= '' and ('%#SLGitBranch# ' .. git .. ' ' .. diff_colored) or '')
      local right         =
          d
          .. '%#Hint#  LSP:' .. lsp_info() .. ' '
          .. '%#Err#'
          .. ''
          .. '%#SLCaps#󰉋 ' .. '%#SLFile# ' .. user .. ' '
          .. '%#SLSepGreen#'
          .. ''
          .. '%#SLCapsGreen#󰈚 ' .. '%#SLInfo# %l:%c '
          .. '%#SLSepGreen#'
      return left .. '%=' .. '%=' .. right
    end,
    inactive = function() return '%#SLInfo# %f %=' end,
  },
})
