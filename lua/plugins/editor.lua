return {
  {
    "nvimdev/lspsaga.nvim",
    config = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      -- "nvim-tree/nvim-web-devicons", -- optional
    },
    vim.keymap.set("n", "<leader>rn", "<CMD>:Lspsaga rename<CR>"),
  },

  {
    "kylechui/nvim-surround",
    event = { "BufReadPre", "BufNewFile" },
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = true,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
    keys = {
      { "<leader>tb", ":DBUIToggle<cr>", mode = "n" },
    },
  },
  {
    "rmagatti/goto-preview",
    -- event = "VeryLazy",
    keys = {

      {
        "<leader>pd",
        function()
          require("goto-preview").goto_preview_definition()
        end,
        { desc = "Preview Definition", silent = true },
      },
      {
        "<leader>pt",
        function()
          require("goto-preview").goto_preview_type_definition()
        end,
        { desc = "Preview Type Definition", silent = true },
      },
      {
        "<leader>pi",
        function()
          require("goto-preview").goto_preview_type_definition()
        end,
        { desc = "Preview Implementation", silent = true },
      },
      {
        "<leader>pr",
        function()
          require("goto-preview").goto_preview_references()
        end,
        { desc = "Preview References", silent = true },
      },
      {
        "<leader>pc",
        function()
          require("goto-preview").close_all_win()
        end,
        { desc = "Close Previews", silent = true },
      },
    },
    config = function()
      require("goto-preview").setup()
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>rf",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
    },
    opts = {},
  },
}
