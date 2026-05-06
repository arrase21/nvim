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
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  desc = "LSP hover actions",
  group = vim.api.nvim_create_augroup('LspCursorHold', { clear = true }),
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients > 0 then
      vim.lsp.buf.document_highlight()
    end
  end,
})

vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  desc = "Clear LSP references",
  group = vim.api.nvim_create_augroup('LspCursorMoved', { clear = true }),
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Actions before saving",
  group = vim.api.nvim_create_augroup("BeforeSave", { clear = true }),
  callback = function()
    -- Ejemplo: formatear con LSP
    vim.lsp.buf.format({ async = false })
  end,
})
