vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})
-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})
--
local function augroup(name)
  return vim.api.nvim_create_augroup("arrase" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "",
  command = ":%s/\\s\\+$//e",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

local function check(path)
  local file = io.open("path", "r")
  if file then
    file:close()
    return true
  end
  return false
end

-- local function fixConfig()
-- 	local path = vim.fn.getcwd() .. "/pyrightconfig.json"
-- 	if not check(path) then
-- 		local temp = [[
--     {
--     "include": ["**/*.py","src"],
--     "exclude": ["**/__pycache__","**/*.pyc","**/*.pyo"],
--     "reportMissingImports": true,
--     "reportMissingTypeStubs": false,
--     "executionEnvironments" : [{
--             "root":"src"
--     }]
--     }
--     ]]
-- 		local file = io.open(path, "w")
-- 		file:write(temp)
-- 		file:close()
-- 		print("Python Configured")
-- 	end
-- end

-- vim.api.nvim_create_autocmd({ "FileType", "BufNewFile", "BufWinEnter" }, {
-- 	group = augroup("PythonConfig"),
-- 	pattern = { "*.py" },
-- 	callback = function()
-- 		fixConfig()
-- 	end,
-- })

-- local selectedTheme = "tokyonight"
local selectedTheme = "solarized-osaka"
vim.api.nvim_create_autocmd({ "ColorScheme", "ColorSchemePre" }, {
  group = augroup("NvimPy_Highlights"),
  pattern = "*",
  callback = function()
    local highlighter = vim.api.nvim_set_hl
    local Theme = require(selectedTheme .. ".colors") -- Selecciona el tema aquí
    local Colors = require("arrase.colors")
    local trans = Theme.default.none

    local function HL(hl, fg, bg, bold)
      if not bg and not bold then
        highlighter(0, hl, { fg = fg, bg = Theme.default.bg, bold = bold })
      elseif not bold then
        highlighter(0, hl, { fg = fg, bg = bg, bold = bold })
      else
        highlighter(0, hl, { fg = fg, bg = bg, bold = bold })
      end
    end
    HL("NvimPyRed", Colors.red["500"], trans)
    HL("NvimPyPurple", Colors.purple["500"], trans)
    HL("NvimPyGreen", Colors.green["500"], trans)
    HL("NvimPyBlue", Colors.blue["500"], trans)
    HL("NvimPyBBlue", Colors.blue["100"], trans)
    HL("NvimPyOrange", Colors.orange["500"], trans)
    HL("NvimPyYellow", Colors.yellow["500"], trans)
    HL("NvimPyCyan", Colors.blue["400"], trans)
    HL("NvimPyTeal", Colors.green["300"], trans)
    HL("NvimPyTrans", trans, trans)
    -- highlighter(0, "CursorLine", { bg = Theme.default.bg })
    -- highlighter(0, "CmpCursorLine", { bg = Theme.default.bg_dark })
    --[[
-- Simple Cmp Highlights
--]]
    --

    HL("CmpItemKindField", Colors.blue["500"], Theme.default.bg_dark)
    HL("CmpItemKindProperty", Colors.purple["500"], Theme.default.bg_dark)
    HL("CmpItemKindEvent", Colors.purple["500"], Theme.default.bg_dark)
    HL("CmpItemKindText", Colors.green["500"], Theme.default.bg_dark)
    HL("CmpItemKindEnum", Colors.green["500"], Theme.default.bg_dark)
    HL("CmpItemKindKeyword", Colors.blue["500"], Theme.default.bg_dark)
    HL("CmpItemKindConstant", Colors.orange["500"], Theme.default.bg_dark)
    HL("CmpItemKindConstructor", Colors.orange["500"], Theme.default.bg_dark)
    HL("CmpItemKindRefrence", Colors.orange["500"], Theme.default.bg_dark)
    HL("CmpItemKindFunction", Colors.purple["500"], Theme.default.bg_dark)
    HL("CmpItemKindStruct", Colors.purple["500"], Theme.default.bg_dark)
    HL("CmpItemKindClass", Colors.purple["500"], Theme.default.bg_dark)
    HL("CmpItemKindModule", Colors.purple["500"], Theme.default.bg_dark)
    HL("CmpItemKindOperator", Colors.purple["500"], Theme.default.bg_dark)
    HL("CmpItemKindVariable", Colors.blue["400"], Theme.default.bg_dark)
    HL("CmpItemKindFile", Colors.blue["400"], Theme.default.bg_dark)
    HL("CmpItemKindUnit", Colors.orange["500"], Theme.default.bg_dark)
    HL("CmpItemKindSnippet", Colors.orange["500"], Theme.default.bg_dark)
    HL("CmpItemKindFolder", Colors.orange["500"], Theme.default.bg_dark)
    HL("CmpItemKindMethod", Colors.yellow["500"], Theme.default.bg_dark)
    HL("CmpItemKindValue", Colors.yellow["500"], Theme.default.bg_dark)
    HL("CmpItemKindEnumMember", Colors.yellow["500"], Theme.default.bg_dark)
    HL("CmpItemKindInterface", Colors.green["500"], Theme.default.bg_dark)
    HL("CmpItemKindColor", Colors.green["500"], Theme.default.bg_dark)
    HL("CmpItemKindTypeParameter", Colors.green["500"], Theme.default.bg_dark)
    HL("CmpItemAbbrMatchFuzzy", Colors.blue["400"], Theme.default.bg_dark)
    HL("CmpItemAbbrMatch", Colors.blue["400"], Theme.default.bg_dark)
    HL("CmpBorder", Theme.default.terminal_black, Theme.default.bg, true)
    HL("CmpBorderDoc", Theme.default.terminal_black, Theme.default.bg, true)
    HL("CmpBorderIconsLT", Colors.blue["400"], Theme.default.bg)
    HL("CmpBorderIconsCT", Colors.orange["500"], Theme.default.bg)
    HL("CmpBorderIconsRT", Colors.green["300"], Theme.default.bg)
    HL("CmpNormal", Colors.purple["500"], Theme.default.bg)
    HL("CmpItemMenu", Colors.blue["400"], Theme.default.bg_dark)
    --[[
-- Telescope
--]]
    HL("TelescopeNormal", Colors.blue["200"], Theme.default.bg)
    HL("TelescopeBorder", Theme.default.trans, trans)
    HL("TelescopePromptNormal", Colors.orange["500"], Theme.default.bg)
    HL("TelescopePromptBorder", Theme.default.trans, Theme.default.bg)
    HL("TelescopePromptTitle", Colors.blue["200"], Theme.default.bg)
    HL("TelescopePreviewTitle", Colors.purple["500"], trans)
    HL("TelescopeResultsTitle", Colors.green["300"], trans)
    HL("TelescopePreviewBorder", Theme.default.terminal_black, trans)
    HL("TelescopeResultsBorder", Theme.default.trans, trans)
    --[[
-- UI
--]]
    HL("CursorLineNr", Colors.blue["200"], trans)
    -- HL("LineNr", Theme.default.terminal_black, trans)
    HL("WinSeparator", Colors.blue["200"], trans, true)
    HL("VertSplit", Colors.blue["200"], trans)
    HL("StatusLine", Colors.blue["200"], trans)
    HL("StatusLineNC", Colors.blue["200"], trans)
    HL("ColorColumn", Colors.purple["500"], trans)
    HL("NeoTreeWinSeparator", Colors.blue["200"], trans)
    HL("NeoTreeStatusLineNC", trans, trans)
    HL("NeoTreeRootName", Colors.purple["500"], trans)
    HL("NeoTreeIndentMarker", Colors.purple["500"], trans)
    HL("Winbar", Theme.default.fg, trans)
    HL("WinbarNC", Theme.default.fg, trans)
    HL("MiniIndentscopeSymbol", Colors.blue["100"], trans)
    HL("FloatBorder", Colors.purple["500"], Theme.default.bg)
    HL("NvimPyTab", Colors.blue["200"], Colors.black)
    HL("Ghost", Theme.default.terminal_black, trans)

    --[[
-- Git colors
--]]
    --

    HL("GitSignsAdd", Colors.green["500"], trans)
    HL("GitSignsChange", Colors.orange["500"], trans)
    HL("GitSignsDelete", Colors.red["500"], trans)
    HL("GitSignsUntracked", Colors.blue["500"], trans)

    --[[
-- DropBar Highlights
--]]
    HL("DropBarIconKindVariable", Colors.blue["200"], trans)
    HL("DropBarIconKindModule", Colors.blue["200"], trans)
    HL("DropBarIconUISeparator", Colors.purple["500"], trans)
    HL("DropBarIconKindFunction", Colors.blue["200"], trans)

    --[[
-- BufferLine
--]]

    HL("BufferLineCloseButtonSelected", Colors.red["500"], trans)
    HL("BufferLineCloseButtonVisible", Colors.orange["500"], trans)
    HL("BufferLineBufferSelected", Colors.purple["500"])
    HL("BufferLineNumbersSelected", Colors.green["500"])
    HL("BufferLineFill", trans, Theme.default.trans)
    HL("BufferCurrent", Colors.blue["500"], trans)
    HL("BufferLineIndicatorSelected", Colors.blue["200"], trans)

    vim.api.nvim_set_hl(0, "NvimPy18", { fg = "#14067E", ctermfg = 18 })
    vim.api.nvim_set_hl(0, "NvimPyPy1", { fg = "#15127B", ctermfg = 18 })
    vim.api.nvim_set_hl(0, "NvimPy17", { fg = "#171F78", ctermfg = 18 })
    vim.api.nvim_set_hl(0, "NvimPy16", { fg = "#182B75", ctermfg = 18 })
    vim.api.nvim_set_hl(0, "NvimPyPy2", { fg = "#193872", ctermfg = 23 })
    vim.api.nvim_set_hl(0, "NvimPy15", { fg = "#1A446E", ctermfg = 23 })
    vim.api.nvim_set_hl(0, "NvimPy14", { fg = "#1C506B", ctermfg = 23 })
    vim.api.nvim_set_hl(0, "NvimPyPy3", { fg = "#1D5D68", ctermfg = 23 })
    vim.api.nvim_set_hl(0, "NvimPy13", { fg = "#1E6965", ctermfg = 23 })
    vim.api.nvim_set_hl(0, "NvimPy12", { fg = "#1F7562", ctermfg = 29 })
    vim.api.nvim_set_hl(0, "NvimPyPy4", { fg = "#21825F", ctermfg = 29 })
    vim.api.nvim_set_hl(0, "NvimPy11", { fg = "#228E5C", ctermfg = 29 })
    vim.api.nvim_set_hl(0, "NvimPy10", { fg = "#239B59", ctermfg = 29 })
    vim.api.nvim_set_hl(0, "NvimPy9", { fg = "#24A755", ctermfg = 29 })
    vim.api.nvim_set_hl(0, "NvimPy8", { fg = "#26B352", ctermfg = 29 })
    vim.api.nvim_set_hl(0, "NvimPyPy5", { fg = "#27C04F", ctermfg = 29 })
    vim.api.nvim_set_hl(0, "NvimPy7", { fg = "#28CC4C", ctermfg = 41 })
    vim.api.nvim_set_hl(0, "NvimPy6", { fg = "#29D343", ctermfg = 41 })
    vim.api.nvim_set_hl(0, "NvimPy5", { fg = "#EC9F05", ctermfg = 214 })
    vim.api.nvim_set_hl(0, "NvimPy4", { fg = "#F08C04", ctermfg = 208 })
    vim.api.nvim_set_hl(0, "NvimPyPy6", { fg = "#F37E03", ctermfg = 208 })
    vim.api.nvim_set_hl(0, "NvimPy3", { fg = "#F77002", ctermfg = 202 })
    vim.api.nvim_set_hl(0, "NvimPy2", { fg = "#FB5D01", ctermfg = 202 })
    vim.api.nvim_set_hl(0, "NvimPy1", { fg = "#FF4E00", ctermfg = 202 })
  end,
})
