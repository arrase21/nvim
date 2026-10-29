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
-- No comments

vim.api.nvim_create_autocmd("FileType", {
   group = vim.api.nvim_create_augroup("no_auto_comment", {}),
   callback = function()
      vim.opt_local.formatoptions:remove({ "c", "r", "o" })
   end,
})

-- Cursor
vim.api.nvim_create_autocmd("BufReadPost", {
   callback = function(args)
      local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
      local line_count = vim.api.nvim_buf_line_count(args.buf)
      if mark[1] > 0 and mark[1] <= line_count then
         vim.api.nvim_win_set_cursor(0, mark)
         vim.schedule(function()
            vim.cmd("normal! zz")
         end)
      end
   end,
})
