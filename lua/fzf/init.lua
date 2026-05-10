local function fzf_ui(cmd, on_select)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })

  local width = math.ceil(vim.o.columns * 0.8)
  local height = math.ceil(vim.o.lines * 0.4)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.ceil((vim.o.columns - width) / 2),
    row = math.ceil((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded'
  })

  local win_opts = { scope = 'local', win = win }
  vim.api.nvim_set_option_value('number', false, win_opts)
  vim.api.nvim_set_option_value('relativenumber', false, win_opts)
  vim.api.nvim_set_option_value('signcolumn', 'no', win_opts)

  local root_result = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")
  local root = (vim.v.shell_error == 0 and root_result[1] and not root_result[1]:match("^fatal"))
      and root_result[1]
      or vim.fn.getcwd()

  local temp = vim.fn.tempname()
  local full_cmd = string.format("cd %s && %s > %s", vim.fn.shellescape(root), cmd, vim.fn.shellescape(temp))

  vim.fn.termopen({ "sh", "-c", full_cmd }, {
    on_exit = function(_, code)
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end

      local function cleanup()
        if vim.fn.filereadable(temp) == 1 then os.remove(temp) end
      end

      if code == 0 and vim.fn.filereadable(temp) == 1 then
        local f = io.open(temp, "r")
        if not f then
          cleanup()
          return
        end
        local content = f:read("*all")
        f:close()
        cleanup()

        local selection = content:gsub("\n$", "")
        if selection ~= "" then
          vim.schedule(function() on_select(selection, root) end)
        end
      else
        cleanup()
      end
    end
  })

  vim.cmd("startinsert")
end

local fzf_base = "fzf --reverse --border=none --margin=0,0 --padding=0,0 --no-popup "
local bat_preview = "bat --color=always --style=numbers"

local function git_checkout(target, notify_msg)
  local output = vim.fn.system("git checkout " .. vim.fn.shellescape(target))
  if vim.v.shell_error == 0 then
    vim.cmd("checktime")
    vim.notify(notify_msg, vim.log.levels.INFO)
  else
    vim.notify("❌ Error: " .. output, vim.log.levels.ERROR)
  end
end

local function open_rg_selection(selection, root)
  local filepath, lnum, col = selection:match("^([^:]+):(%d+):(%d+):")
  if filepath and lnum and col then
    vim.cmd("edit " .. vim.fn.fnameescape(root .. "/" .. filepath))
    vim.api.nvim_win_set_cursor(0, { tonumber(lnum), tonumber(col) - 1 })
  end
end

local harpoon_file = vim.fn.stdpath("data") .. "/harpoon.json"

local function harpoon_load()
  local f = io.open(harpoon_file, "r")
  if not f then return {} end
  local content = f:read("*all")
  f:close()
  local ok, data = pcall(vim.fn.json_decode, content)
  return (ok and data) or {}
end

local function harpoon_save(data)
  local f = io.open(harpoon_file, "w")
  if not f then return end
  f:write(vim.fn.json_encode(data))
  f:close()
end

local function harpoon_key()
  local root_result = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")
  if vim.v.shell_error == 0 and root_result[1] and not root_result[1]:match("^fatal") then
    return root_result[1]
  end
  return vim.fn.getcwd()
end


local M = {}

M.harpoon_add = function()
  local key = harpoon_key()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("No hay archivo abierto", vim.log.levels.WARN)
    return
  end

  local data = harpoon_load()
  data[key] = data[key] or {}

  for _, f in ipairs(data[key]) do
    if f == file then
      vim.notify("Ya está en harpoon: " .. vim.fn.fnamemodify(file, ":~:."), vim.log.levels.WARN)
      return
    end
  end

  table.insert(data[key], file)
  harpoon_save(data)
  vim.notify("🪝 Harpoon: " .. vim.fn.fnamemodify(file, ":~:."), vim.log.levels.INFO)
end

M.harpoon_open = function()
  local key = harpoon_key()
  local data = harpoon_load()
  local files = data[key]

  if not files or #files == 0 then
    vim.notify("No hay archivos en harpoon", vim.log.levels.WARN)
    return
  end

  local list = table.concat(files, "\n")
  local preview = string.format("--preview '%s --line-range :500 {}' --preview-window=right:60%%", bat_preview)
  local cmd = string.format("echo %s | %s", vim.fn.shellescape(list), fzf_base .. preview)

  fzf_ui(cmd, function(selection)
    vim.cmd("edit " .. vim.fn.fnameescape(selection))
  end)
end

M.harpoon_remove = function()
  local key = harpoon_key()
  local data = harpoon_load()
  local files = data[key]

  if not files or #files == 0 then
    vim.notify("No hay archivos en harpoon", vim.log.levels.WARN)
    return
  end

  local list = table.concat(files, "\n")
  local preview = string.format("--preview '%s --line-range :500 {}' --preview-window=right:60%%", bat_preview)
  local cmd = string.format("echo %s | %s", vim.fn.shellescape(list), fzf_base .. preview ..
    " --header 'Enter para eliminar de harpoon'")

  fzf_ui(cmd, function(selection)
    local new_files = {}
    for _, f in ipairs(files) do
      if f ~= selection then
        table.insert(new_files, f)
      end
    end
    data[key] = new_files
    harpoon_save(data)
    vim.notify("🗑️  Harpoon eliminado: " .. vim.fn.fnamemodify(selection, ":~:."), vim.log.levels.INFO)
  end)
end

M.harpoon_jump = function(index)
  local key = harpoon_key()
  local data = harpoon_load()
  local files = data[key]

  if not files or #files == 0 then
    vim.notify("No hay archivos en harpoon", vim.log.levels.WARN)
    return
  end

  local file = files[index]
  if not file then
    vim.notify("No hay archivo en posición " .. index, vim.log.levels.WARN)
    return
  end

  vim.cmd("edit " .. vim.fn.fnameescape(file))
end

local sessions_dir = vim.fn.expand("~/.local/share/nvim/sessions")

vim.fn.mkdir(sessions_dir, "p")

M.session_load = function()
  local cmd = string.format("ls %s", vim.fn.shellescape(sessions_dir))
  local fzf_cmd = fzf_base .. " --header 'Enter para cargar la sesión'"
  fzf_ui(cmd .. " | " .. fzf_cmd, function(selection)
    vim.cmd("source " .. vim.fn.fnameescape(sessions_dir .. "/" .. selection))
    vim.notify("✅ Sesión cargada: " .. selection, vim.log.levels.INFO)
  end)
end

M.session_save = function()
  vim.ui.input({ prompt = "Nombre de sesión: " }, function(name)
    if not name or name == "" then return end
    local path = sessions_dir .. "/" .. name ..
        vim.cmd("mksession! " .. vim.fn.fnameescape(path))
    vim.notify("✅ Sesión guardada: " .. name, vim.log.levels.INFO)
  end)
end

M.session_delete = function()
  local cmd = string.format("ls %s", vim.fn.shellescape(sessions_dir))
  local fzf_cmd = fzf_base .. " --header 'Enter para BORRAR la sesión'"
  fzf_ui(cmd .. " | " .. fzf_cmd, function(selection)
    local path = sessions_dir .. "/" .. selection
    os.remove(path)
    vim.notify("🗑️  Sesión borrada: " .. selection, vim.log.levels.INFO)
  end)
end

M.files = function()
  local cmd = fzf_base ..
      string.format("--preview '%s --line-range :500 {}' --preview-window=right:60%%", bat_preview)
  fzf_ui(cmd, function(selection, root)
    vim.cmd("edit " .. vim.fn.fnameescape(root .. "/" .. selection))
  end)
end

M.grep = function()
  local rg = "rg --column --line-number --no-heading --color=always --smart-case ''"
  local preview = string.format("--preview '%s --highlight-line {2} {1}' --preview-window=right:60%%", bat_preview)
  fzf_ui(rg .. " | " .. fzf_base .. "--ansi --delimiter ':' " .. preview, open_rg_selection)
end

M.grep_word = function()
  local word = vim.fn.expand('<cword>')
  local rg = "rg --column --line-number --no-heading --color=always --smart-case " .. vim.fn.shellescape(word)
  local preview = string.format("--preview '%s --highlight-line {2} {1}' --preview-window=right:60%%", bat_preview)
  fzf_ui(rg .. " | " .. fzf_base .. "--ansi --delimiter ':' " .. preview, open_rg_selection)
end

M.branches = function()
  local cmd = "git branch -a --color=always | grep -v '/HEAD' | sed 's/^[* ]*//'"
  local fzf_cmd = fzf_base .. "--ansi --preview 'git log --color=always {}'"
  fzf_ui(cmd .. " | " .. fzf_cmd, function(selection)
    local branch = selection:gsub("^remotes/[^/]+/", "")
    git_checkout(branch, "✅ Branch: " .. branch)
  end)
end

M.commits = function()
  local cmd = "git log --oneline --color=always"
  local fzf_cmd = fzf_base ..
      "--ansi " ..
      "--preview 'git show --color=always {1}' " ..
      "--header 'Enter para hacer CHECKOUT a este commit (detached HEAD)'"
  fzf_ui(cmd .. " | " .. fzf_cmd, function(selection)
    local hash = selection:match("^(%S+)")
    if hash then
      git_checkout(
        hash,
        "🚀 Commit: " .. hash .. "\n⚠️  Estás en modo detached HEAD.\nCrea un branch con: git switch -c <nombre>"
      )
    end
  end)
end

M.status = function()
  local cmd = "git status --short"
  local fzf_cmd = fzf_base .. "--preview 'git diff --color=always {2}'"
  fzf_ui(cmd .. " | " .. fzf_cmd, function(selection, root)
    local file = selection:match("^..(.*)")
    if file then
      file = file:match("^%s*(.-)%s*$")
      local renamed = file:match("^.+ %-> (.+)$")
      file = renamed or file
      vim.cmd("edit " .. vim.fn.fnameescape(root .. "/" .. file))
    else
      vim.notify("❌ No se pudo parsear el archivo: " .. selection, vim.log.levels.ERROR)
    end
  end)
end

M.diff = function()
  local cmd = "git diff --name-only"
  local fzf_cmd = fzf_base .. "--preview 'git diff --color=always {}' --preview-window=right:70%"
  fzf_ui(cmd .. " | " .. fzf_cmd, function(selection, root)
    vim.cmd("edit " .. vim.fn.fnameescape(root .. "/" .. selection))
  end)
end

M.stash = function()
  local cmd = "git stash list"
  local fzf_cmd = fzf_base ..
      "--preview 'git stash show -p --color=always {1}' " ..
      "--preview-window=right:70% " ..
      "--header 'Enter para aplicar el stash'"
  fzf_ui(cmd .. " | " .. fzf_cmd, function(selection)
    local stash = selection:match("^(stash@{%d+})")
    if stash then
      local output = vim.fn.system("git stash apply " .. vim.fn.shellescape(stash))
      if vim.v.shell_error == 0 then
        vim.cmd("checktime")
        vim.notify("✅ Stash aplicado: " .. stash, vim.log.levels.INFO)
      else
        vim.notify("❌ Error: " .. output, vim.log.levels.ERROR)
      end
    end
  end)
end

M.buffers = function()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  table.sort(buffers, function(a, b) return a.lastused > b.lastused end)

  local lines = {}
  for _, buf in ipairs(buffers) do
    if buf.name ~= "" then
      table.insert(lines, buf.name)
    end
  end

  if #lines == 0 then
    vim.notify("No hay buffers abiertos", vim.log.levels.WARN)
    return
  end

  local list = table.concat(lines, "\n")
  local preview = string.format("--preview '%s --line-range :500 {}' --preview-window=right:60%%", bat_preview)
  local cmd = string.format("echo %s | %s", vim.fn.shellescape(list), fzf_base .. preview)

  fzf_ui(cmd, function(selection)
    vim.cmd("edit " .. vim.fn.fnameescape(selection))
  end)
end

M.todos = function()
  local patterns = "TODO|FIXME|HACK|NOTE|BUG|WARN"
  local rg = string.format("rg --column --line-number --no-heading --color=always -e '%s'", patterns)
  -- local preview = string.format("--preview '%s --highlight-line {2} {1}' --preview-window=right:60%%", bat_preview)
  local preview = string.format("--preview '%s --line-range {3}: --highlight-line {3} {4}' --preview-window=right:60%%",
    bat_preview)
  fzf_ui(rg .. " | " .. fzf_base .. "--ansi --delimiter ':' " .. preview, open_rg_selection)
end

M.lsp_symbols = function()
  local client = vim.lsp.get_clients({ bufnr = 0 })[1]
  if not client then
    vim.notify("No hay cliente LSP activo", vim.log.levels.WARN)
    return
  end

  local filepath = vim.fn.expand('%:p')
  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
  local results = vim.lsp.buf_request_sync(0, 'textDocument/documentSymbol', params, 2000)

  if not results or vim.tbl_isempty(results) then
    vim.notify("No hay símbolos LSP disponibles", vim.log.levels.WARN)
    return
  end

  local symbols = {}
  for _, res in pairs(results) do
    if res.result then
      for _, sym in ipairs(res.result) do
        local kind = vim.lsp.protocol.SymbolKind[sym.kind] or "Unknown"
        local lnum = sym.range and sym.range.start.line + 1 or 0
        table.insert(symbols, string.format("%s\t%s\t%d\t%s", kind, sym.name, lnum, filepath))
      end
    end
  end

  if #symbols == 0 then
    vim.notify("No se encontraron símbolos", vim.log.levels.WARN)
    return
  end

  local list = table.concat(symbols, "\n")
  local fzf_cmd = fzf_base ..
      "--delimiter '\t' " ..
      "--with-nth 1,2 " ..
      string.format("--preview '%s --line-range {3}: --highlight-line {3} {4}' --preview-window=right:60%%", bat_preview)

  local cmd = string.format("echo %s | %s", vim.fn.shellescape(list), fzf_cmd)

  fzf_ui(cmd, function(selection)
    local lnum = tonumber(selection:match("\t(%d+)\t"))
    if lnum then
      vim.api.nvim_win_set_cursor(0, { lnum, 0 })
      vim.cmd("normal! zz")
    end
  end)
end

-- Keymaps
vim.keymap.set('n', '<leader>zf', M.files, { desc = 'FZF: Files' })
vim.keymap.set('n', '<leader>zg', M.grep, { desc = 'FZF: Texto' })
vim.keymap.set('n', '<leader>zw', M.grep_word, { desc = 'FZF: Word cursor' })
vim.keymap.set('n', '<leader>zb', M.branches, { desc = 'FZF Git: Branches' })
vim.keymap.set('n', '<leader>zl', M.commits, { desc = 'FZF Git: Commits' })
vim.keymap.set('n', '<leader>zs', M.status, { desc = 'FZF Git: Status' })
vim.keymap.set('n', '<leader>zd', M.diff, { desc = 'FZF Git: Diff' })
vim.keymap.set('n', '<leader>zs', M.stash, { desc = 'FZF Git: Stash' })
vim.keymap.set('n', '<leader>zr', M.buffers, { desc = 'FZF: Buffers' })
vim.keymap.set('n', '<leader>zt', M.todos, { desc = 'FZF: TODOs' })
vim.keymap.set('n', '<leader>zS', M.lsp_symbols, { desc = 'FZF: Símbolos LSP' })

vim.keymap.set('n', '<leader>rno', M.session_load, { desc = 'FZF: Load sesión' })
vim.keymap.set('n', '<leader>rns', M.session_save, { desc = 'FZF: Save sesión' })
vim.keymap.set('n', '<leader>rnd', M.session_delete, { desc = 'FZF: Delete sesión' })

vim.keymap.set('n', '<leader>ha', M.harpoon_add, { desc = 'Harpoon: Add' })
vim.keymap.set('n', '<leader>ho', M.harpoon_open, { desc = 'Harpoon: Open' })
vim.keymap.set('n', '<leader>hd', M.harpoon_remove, { desc = 'Harpoon: Delete archivo' })

for i = 1, 9 do
  vim.keymap.set('n', '<leader>h' .. i, function() M.harpoon_jump(i) end,
    { desc = 'Harpoon: Saltar a archivo ' .. i })
end

return M
