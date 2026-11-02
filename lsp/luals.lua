return {
   cmd = { "lua-language-server" },
   filetypes = { "lua" },
   root_markers = {
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      ".git",
   },

   settings = {
      Lua = {
         diagnostics = {
            globals = { "vim" },
         },

         runtime = {
            version = "LuaJIT",
         },

         workspace = {
            checkThirdParty = false,
         },

         completion = {
            callSnippet = "Replace",
         },

         codeLens = {
            enable = true,
         },

         doc = {
            privateName = { "^_" },
         },

         hint = {
            enable = true,
            setType = false,
            paramType = true,
            paramName = "Disable",
            semicolon = "Disable",
            arrayIndex = "Disable",
         },

         signatureHelp = {
            enabled = true,
         },

         semantic = {
            enable = false,
         },

         telemetry = {
            enable = false,
         },
      },
   },
}
