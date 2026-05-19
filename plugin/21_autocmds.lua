-- 2. Yank Highlight (Limpio)
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = "Highlight text on yank",
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 180,
    })
  end,
})

-- 3. Fix Format Options (Con grupo para evitar leaks)
vim.api.nvim_create_autocmd("FileType", {
  desc = "Disable automatic comment continuation",
  group = vim.api.nvim_create_augroup("FixFormatOptions", { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end
})

Config.new_autocmd("BufReadPost", "*", function(event)
  local exclude = { "gitcommit" }
  local buf = event.buf
  if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].vim_last_loc then
    return
  end
  vim.b[buf].vim_last_loc = true
  local mark = vim.api.nvim_buf_get_mark(buf, '"')
  local lcount = vim.api.nvim_buf_line_count(buf)
  if mark[1] > 0 and mark[1] <= lcount then
    pcall(vim.api.nvim_win_set_cursor, 0, mark)
  end
end, "Restore last cursor position")


-- Highlight del símbolo bajo el cursor via LSP
-- vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--   desc = "LSP hover actions",
--   group = vim.api.nvim_create_augroup('LspCursorHold', { clear = true }),
--   callback = function()
--     vim.diagnostic.open_float(nil, { focusable = false })
--     local clients = vim.lsp.get_clients({ bufnr = 0 })
--     if #clients > 0 then
--       vim.lsp.buf.document_highlight()
--     end
--   end,
-- })

vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  desc = "Clear LSP references",
  group = vim.api.nvim_create_augroup('LspCursorMoved', { clear = true }),
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})

local format_group = vim.api.nvim_create_augroup(
  "lsp_autoformat",
  { clear = false }
)

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP format on save",
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if not client then
      return
    end

    if not client:supports_method("textDocument/formatting") then
      return
    end

    vim.api.nvim_clear_autocmds({
      group = format_group,
      buffer = event.buf,
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = format_group,
      buffer = event.buf,
      callback = function()
        vim.lsp.buf.format({
          bufnr = event.buf,
          async = false,
          timeout_ms = 800,
        })
      end,
    })
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniStarterOpened',
  callback = function()
    MiniClue.ensure_buf_triggers()
  end,
})

-- Función nativa para colorear códigos Hexadecimales en el buffer actual
local function colorear_css_nativo()
  local ns = vim.api.nvim_create_namespace("CSSColoresNativos")
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

  local lineas = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for num_linea, linea in ipairs(lineas) do
    -- Busca patrones tipo #RRGGBB
    for hex in linea:gmatch("#%x%x%x%x%x%x") do
      local ini, fin = linea:find(hex)
      if ini then
        local name = "Hex_" .. hex:sub(2)
        -- Crea el grupo de resaltado nativo
        vim.api.nvim_set_hl(0, name, { fg = "#000000", bg = hex })
        -- Aplica el color al buffer
        vim.api.nvim_buf_add_highlight(0, ns, name, num_linea - 1, ini - 1, fin)
      end
    end
  end
end

-- Ejecutar automáticamente al abrir o modificar archivos CSS
vim.api.nvim_create_autocmd({ "BufReadPost", "TextChanged", "TextChangedI" }, {
  pattern = { "*.css", "*.html", "*.js" },
  callback = colorear_css_nativo,
})
