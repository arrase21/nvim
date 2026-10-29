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
