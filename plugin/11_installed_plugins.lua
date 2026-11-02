local gh = function(x) return "https://github.com/" .. x end

vim.pack.add({
   -- Themes
   gh("rebelot/kanagawa.nvim"),
   gh("arrase21/dracula.nvim"),
   gh("arrase21/gruvbox"),
   gh("duxlabs-dev/base46"),
   -- TreeSitter
   gh("romus204/tree-sitter-manager.nvim"),
   -- Picker/Explorer
   gh("arrase21/fzfnvim"),
   gh('arrase21/fyler.nvim'),
   -- Dap
   gh("mfussenegger/nvim-dap"),
   gh("rcarriga/nvim-dap-ui"),
   gh("nvim-neotest/nvim-nio"),
   gh("mfussenegger/nvim-dap-python"),
   gh("leoluz/nvim-dap-go"),
   gh("mfussenegger/nvim-jdtls"),
   --Kulala
   gh("mistweaverco/kulala.nvim"),
   -- Blink
   gh("saghen/blink.lib"),
   gh("saghen/blink.cmp"),
})
