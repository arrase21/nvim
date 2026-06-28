pcall(vim.cmd, "packadd nvim-jdtls")

local status_ok, jdtls = pcall(require, "jdtls")
if not status_ok then
  return
end

local function get_jdtls_install_dir()
  return vim.fn.expand('~/.local/share/jdtls')
end

local function get_jdtls_launcher_jar()
  local pattern = get_jdtls_install_dir() .. '/plugins/org.eclipse.equinox.launcher_*.jar'
  local jars = vim.fn.glob(pattern, false, true)
  return jars[1]
end

local function get_java_debug_jar()
  local pattern = vim.fn.expand(
    '~/.local/share/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar')
  local jars = vim.fn.glob(pattern, false, true)
  return jars[1]
end

local function get_jdtls_config_dir()
  if vim.fn.has('mac') == 1 then
    return get_jdtls_install_dir() .. '/config_mac'
  elseif vim.fn.has('win32') == 1 then
    return get_jdtls_install_dir() .. '/config_win'
  end
  return get_jdtls_install_dir() .. '/config_linux'
end

local function get_jdtls_cache_dir()
  return vim.fn.stdpath('cache') .. '/jdtls'
end

local root_markers = { 'mvnw', 'gradlew', 'settings.gradle', 'settings.gradle.kts', 'pom.xml', '.git' }
local root_dir = vim.fs.root(0, root_markers) or vim.fn.getcwd()

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', get_jdtls_launcher_jar(),
    '-configuration', get_jdtls_config_dir(),
    '-data', get_jdtls_cache_dir() .. '/workspace/' .. vim.fn.fnamemodify(root_dir, ':t')
  },
  
  root_dir = root_dir,
  filetypes = { 'java' },

  -- TU FILTRO DE PROGRESO ORIGINAL INTACTO
  handlers = {
    ['$/progress'] = function(_, result, ctx)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if client and client.name == "jdtls" then
        return
      end
      vim.lsp.handlers['$/progress'](_, result, ctx)
    end
  },

  init_options = {
    bundles = {
      get_java_debug_jar()
    },
    settings = {
      java = {},
    },
  },

  on_attach = function(client, bufnr)
    local status_dap, jdtls_dap = pcall(require, "jdtls")
    if status_dap then
      jdtls_dap.setup_dap({ hotcodereplace = 'auto' })
    end
  end,
}
jdtls.start_or_attach(config)

-- local home = os.getenv 'HOME'
-- local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'
-- local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
-- local workspace_dir = workspace_path .. project_name
--
-- local status, jdtls = pcall(require, 'jdtls')
-- if not status then
--   return
-- end
-- local extendedClientCapabilities = jdtls.extendedClientCapabilities
--
-- local bundles = vim.fn.glob(
--   home .. '/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar',
--   false, true
-- )
-- vim.list_extend(bundles, vim.fn.glob(
--   home .. '/.local/share/nvim/mason/packages/java-test/extension/server/*.jar',
--   false, true
-- ))
--
-- local config = {
--   cmd = {
--     'java',
--     '-Declipse.application=org.eclipse.jdt.ls.core.id1',
--     '-Dosgi.bundles.defaultStartLevel=4',
--     '-Declipse.product=org.eclipse.jdt.ls.core.product',
--     '-Dlog.protocol=true',
--     '-Dlog.level=ALL',
--     '-Xmx1g',
--     '--add-modules=ALL-SYSTEM',
--     '--add-opens',
--     'java.base/java.util=ALL-UNNAMED',
--     '--add-opens',
--     'java.base/java.lang=ALL-UNNAMED',
--     '-javaagent:' .. home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar',
--     '-jar',
--     vim.fn.glob(home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
--     '-configuration',
--     home .. '/.local/share/nvim/mason/packages/jdtls/config_linux',
--     '-data',
--     workspace_dir,
--   },
--   root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },
--
--   on_attach = function(client, bufnr)
--     vim.notify('[jdtls] Workspace loaded: ' .. vim.fn.getcwd(), vim.log.levels.INFO, { title = 'jdtls' })
--     jdtls.setup_dap({ hotcodereplace = 'auto' })
--   end,
--
--   handlers = {
--     ['$/progress'] = function(_, result, ctx)
--       local client = vim.lsp.get_client_by_id(ctx.client_id)
--       if client and client.name == "jdtls" then
--         if result.kind == 'begin' then
--           vim.notify('[jdtls] ' .. result.title, vim.log.levels.INFO, { title = 'jdtls' })
--         elseif result.kind == 'end' then
--           vim.notify('[jdtls] ' .. result.title .. ' — OK', vim.log.levels.INFO, { title = 'jdtls' })
--         end
--         return
--       end
--       vim.lsp.handlers['$/progress'](_, result, ctx)
--     end,
--   },
--   settings = {
--     java = {
--       signatureHelp = { enabled = true },
--       extendedClientCapabilities = extendedClientCapabilities,
--       maven = {
--         downloadSources = true,
--       },
--       referencesCodeLens = {
--         enabled = true,
--       },
--       references = {
--         includeDecompiledSources = true,
--       },
--       inlayHints = {
--         parameterNames = {
--           enabled = 'all', -- literals, all, none
--         },
--       },
--       format = {
--         enabled = false,
--       },
--     },
--   },
--
--   init_options = {
--     bundles = bundles,
--   },
-- }
-- require('jdtls').start_or_attach(config)
--
-- vim.api.nvim_create_autocmd('VimLeavePre', {
--   callback = function()
--     for _, client in ipairs(vim.lsp.get_clients({ name = 'jdtls' })) do
--       client.stop(true)
--     end
--   end,
-- })
