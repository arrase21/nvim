-- Crear un buffer
local buf = vim.api.nvim_create_buf(false, true)

-- Definir colores
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1e1e2e' })
vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#61afef', bg = '#1e1e2e' })

-- Configuración de la ventana
local opts = {
  relative = 'editor',
  width = 50,
  height = 10,
  row = 10,
  col = 10,
  style = 'minimal',
  border = 'rounded',
  title = 'Ventana Estilizada',
  title_pos = 'center',
}

local win = vim.api.nvim_open_win(buf, true, opts)
vim.api.nvim_win_set_option(win, 'winhighlight', 'NormalFloat:NormalFloat,FloatBorder:FloatBorder')
vim.api.nvim_win_set_option(win, 'winblend', 10) -- Transparencia ligera
