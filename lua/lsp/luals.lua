-- lua/lsp/luals.lua
-- vim.lsp.config["lua_ls"] = {
--   cmd = { "lua-language-server" },
--   filetypes = { "lua" },
--   root_markers = { ".luarc.json", ".luarc.jsonc" },
--   telemetry = { enabled = false },
--   formatters = {
--     ignoreComments = false,
--   },
--   settings = {
--     Lua = {
--       runtime = {
--         version = "LuaJIT",
--       },
--       signatureHelp = { enabled = true },
--     },
--   },
-- }
--
-- -- arrancar inmediatamente
-- vim.lsp.enable("lua_ls")

return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      signatureHelp = { enabled = true },
    },
  },
}
