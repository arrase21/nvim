---@brief
--- @class go_dir_custom_args
---
--- @field envvar_id string
---
--- @field custom_subdir string?

local mod_cache = nil
local std_lib = nil

---@param custom_args go_dir_custom_args
---@param on_complete fun(dir: string | nil)
local function identify_go_dir(custom_args, on_complete)
  local cmd = { 'go', 'env', custom_args.envvar_id }

  vim.system(cmd, { text = true }, function(output)
    local res = vim.trim(output.stdout or '')

    if output.code == 0 and res ~= '' then
      if custom_args.custom_subdir and custom_args.custom_subdir ~= '' then
        res = res .. custom_args.custom_subdir
      end

      on_complete(res)
      return
    end

    vim.schedule(function()
      vim.notify(
        ('[gopls] identify %s dir cmd failed with code %d: %s\n%s'):format(
          custom_args.envvar_id,
          output.code,
          vim.inspect(cmd),
          output.stderr or ''
        ),
        vim.log.levels.WARN
      )
    end)

    on_complete(nil)
  end)
end

---@param path string
---@param dir string
---@return boolean
local function is_inside(path, dir)
  return path == dir or vim.startswith(path, dir .. '/')
end

---@param on_complete fun()
local function initialize_go_dirs(on_complete)
  if mod_cache and std_lib then
    on_complete()
    return
  end

  local pending = 0

  local function done()
    pending = pending - 1

    if pending == 0 then
      on_complete()
    end
  end

  if not mod_cache then
    pending = pending + 1

    identify_go_dir({
      envvar_id = 'GOMODCACHE',
    }, function(dir)
      if dir then
        mod_cache = dir
      end

      done()
    end)
  end

  if not std_lib then
    pending = pending + 1

    identify_go_dir({
      envvar_id = 'GOROOT',
      custom_subdir = '/src',
    }, function(dir)
      if dir then
        std_lib = dir
      end

      done()
    end)
  end

  if pending == 0 then
    on_complete()
  end
end

---@param fname string
---@return string?
local function get_root_dir(fname)
  -- Files inside the Go module cache belong to the current gopls workspace.
  if mod_cache and is_inside(fname, mod_cache) then
    local clients = vim.lsp.get_clients({ name = 'gopls' })

    if #clients > 0 then
      return clients[#clients].config.root_dir
    end
  end

  -- Files inside the Go standard library belong to the current gopls workspace.
  if std_lib and is_inside(fname, std_lib) then
    local clients = vim.lsp.get_clients({ name = 'gopls' })

    if #clients > 0 then
      return clients[#clients].config.root_dir
    end
  end

  -- Normal Go project root detection.
  return vim.fs.root(fname, 'go.work')
    or vim.fs.root(fname, 'go.mod')
    or vim.fs.root(fname, '.git')
end

---@type vim.lsp.Config
return {
  cmd = { 'gopls' },

  filetypes = {
    'go',
    'gomod',
    'gowork',
    'gotmpl',
  },

  capabilities = {
    offsetEncoding = {
      'utf-8',
      'utf-16',
    },
  },

  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)

    initialize_go_dirs(function()
      on_dir(get_root_dir(fname))
    end)
  end,

  settings = {
    gopls = {
      gofumpt = true,

      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },

      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },

      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },

      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,

      directoryFilters = {
        '-.git',
        '-.vscode',
        '-.idea',
        '-.vscode-test',
        '-node_modules',
      },

      semanticTokens = false,
    },
  },
}


-- ---@brief
-- --- @class go_dir_custom_args
-- ---
-- --- @field envvar_id string
-- ---
-- --- @field custom_subdir string?
--
-- local mod_cache = nil
-- local std_lib = nil
--
-- ---@param custom_args go_dir_custom_args
-- ---@param on_complete fun(dir: string | nil)
-- local function identify_go_dir(custom_args, on_complete)
--   local cmd = { 'go', 'env', custom_args.envvar_id }
--
--   vim.system(cmd, { text = true }, function(output)
--     local res = vim.trim(output.stdout or '')
--
--     if output.code == 0 and res ~= '' then
--       if custom_args.custom_subdir and custom_args.custom_subdir ~= '' then
--         res = res .. custom_args.custom_subdir
--       end
--
--       on_complete(res)
--       return
--     end
--
--     vim.schedule(function()
--       vim.notify(
--         ('[gopls] identify %s dir cmd failed with code %d: %s\n%s'):format(
--           custom_args.envvar_id,
--           output.code,
--           vim.inspect(cmd),
--           output.stderr or ''
--         ),
--         vim.log.levels.WARN
--       )
--     end)
--
--     on_complete(nil)
--   end)
-- end
--
-- ---@param path string
-- ---@param dir string
-- ---@return boolean
-- local function is_inside(path, dir)
--   return path == dir or vim.startswith(path, dir .. '/')
-- end
--
-- ---@param on_complete fun()
-- local function initialize_go_dirs(on_complete)
--   if mod_cache and std_lib then
--     on_complete()
--     return
--   end
--
--   local pending = 0
--
--   local function done()
--     pending = pending - 1
--
--     if pending == 0 then
--       on_complete()
--     end
--   end
--
--   if not mod_cache then
--     pending = pending + 1
--
--     identify_go_dir({
--       envvar_id = 'GOMODCACHE',
--     }, function(dir)
--       if dir then
--         mod_cache = dir
--       end
--
--       done()
--     end)
--   end
--
--   if not std_lib then
--     pending = pending + 1
--
--     identify_go_dir({
--       envvar_id = 'GOROOT',
--       custom_subdir = '/src',
--     }, function(dir)
--       if dir then
--         std_lib = dir
--       end
--
--       done()
--     end)
--   end
--
--   if pending == 0 then
--     on_complete()
--   end
-- end
--
-- ---@param fname string
-- ---@return string?
-- local function get_root_dir(fname)
--   -- Files inside the Go module cache belong to the current gopls workspace.
--   if mod_cache and is_inside(fname, mod_cache) then
--     local clients = vim.lsp.get_clients({ name = 'gopls' })
--
--     if #clients > 0 then
--       return clients[#clients].config.root_dir
--     end
--   end
--
--   -- Files inside the Go standard library belong to the current gopls workspace.
--   if std_lib and is_inside(fname, std_lib) then
--     local clients = vim.lsp.get_clients({ name = 'gopls' })
--
--     if #clients > 0 then
--       return clients[#clients].config.root_dir
--     end
--   end
--
--   -- Normal Go project root detection.
--   return vim.fs.root(fname, 'go.work')
--     or vim.fs.root(fname, 'go.mod')
--     or vim.fs.root(fname, '.git')
-- end
--
-- ---@type vim.lsp.Config
-- return {
--   cmd = { 'gopls' },
--
--   filetypes = {
--     'go',
--     'gomod',
--     'gowork',
--     'gotmpl',
--   },
--
--   capabilities = {
--     offsetEncoding = {
--       'utf-8',
--       'utf-16',
--     },
--   },
--
--   root_dir = function(bufnr, on_dir)
--     local fname = vim.api.nvim_buf_get_name(bufnr)
--
--     initialize_go_dirs(function()
--       on_dir(get_root_dir(fname))
--     end)
--   end,
--
--   settings = {
--     gopls = {
--       gofumpt = true,
--
--       codelenses = {
--         gc_details = false,
--         generate = true,
--         regenerate_cgo = true,
--         run_govulncheck = true,
--         test = true,
--         tidy = true,
--         upgrade_dependency = true,
--         vendor = true,
--       },
--
--       hints = {
--         assignVariableTypes = true,
--         compositeLiteralFields = true,
--         compositeLiteralTypes = true,
--         constantValues = true,
--         functionTypeParameters = true,
--         parameterNames = true,
--         rangeVariableTypes = true,
--       },
--
--       analyses = {
--         nilness = true,
--         unusedparams = true,
--         unusedwrite = true,
--         useany = true,
--       },
--
--       usePlaceholders = true,
--       completeUnimported = true,
--       staticcheck = true,
--
--       directoryFilters = {
--         '-.git',
--         '-.vscode',
--         '-.idea',
--         '-.vscode-test',
--         '-node_modules',
--       },
--
--       semanticTokens = false,
--     },
--   },
-- }
