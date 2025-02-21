return {
  {
    "nvim-telescope/telescope.nvim",
    event = { "VeryLazy" },
    dependencies = {
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    keys = {
      -- {
      --   "<leader>fb",
      --   "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
      --   desc = "Switch Buffer",
      -- },
      -- { "<leader>ff", "<cmd>Telescope find_files <cr>", { root = false }, desc = "Find Files (cwd)" },
      -- { "<leader>fR", "<cmd>Telescope oldfiles<cr>", { cwd = vim.uv.cwd() }, desc = "Recent (cwd)" },
      --
      -- { "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      -- { "<leader>fw", "<cmd>Telescope grep_string<cr>", { word_match = "-w" }, desc = "Word (Root Dir)" },
      -- { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep (Root Dir)" },
      -- { "<leader>fG", "<cmd>Telescope live_grep <cr>", { root = false }, desc = "Grep (cwd)" },
      -- { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      -- { "<leader>s", "<cmd>Telescope auto <cr>", desc = "Find Files (Root Dir)" },
      -- { "<leader>fB", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
      -- -- git
      -- { "<leader>fgi", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
      -- { "<leader>fgc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
      -- { "<leader>fgs", "<cmd>Telescope git_status<CR>", desc = "Status" },
      {
        "<Leader>fs",
        function()
          local telescope = require("telescope")

          local function telescope_buffer_dir()
            return vim.fn.expand("%:p:h")
          end

          telescope.extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd = telescope_buffer_dir(),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = "normal",
            layout_config = { height = 40 },
          })
        end,
        desc = "Open File Browser with the path of the current buffer",
      },
    },
    -- 	keys = {
    -- 		{
    -- 			"<leader>fP",
    -- 			function()
    -- 				require("telescope.builtin").find_files({
    -- 					cwd = require("lazy.core.config").options.root,
    -- 				})
    -- 			end,
    -- 			desc = "Find Plugin File",
    -- 		},
    -- 		{
    -- 			";f",
    -- 			function()
    -- 				local builtin = require("telescope.builtin")
    -- 				builtin.find_files({
    -- 					no_ignore = false,
    -- 					hidden = true,
    -- 				})
    -- 			end,
    -- 			desc = "Lists files in your current working directory, respects .gitignore",
    -- 		},
    --
    -- 		{ ";r", "live_grep", desc = "Grep (Root Dir)" },
    -- 		-- {
    -- 		-- 	";r",
    -- 		-- 	function()
    -- 		-- 		local builtin = require("telescope.builtin")
    -- 		-- 		builtin.live_grep({
    -- 		-- 			additional_args = { "--hidden" },
    -- 		-- 		})
    -- 		-- 	end,
    -- 		-- 	desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
    -- 		-- },
    -- 		{
    -- 			"\\\\",
    -- 			function()
    -- 				local builtin = require("telescope.builtin")
    -- 				builtin.buffers()
    -- 			end,
    -- 			desc = "Lists open buffers",
    -- 		},
    -- 		{
    -- 			";t",
    -- 			function()
    -- 				local builtin = require("telescope.builtin")
    -- 				builtin.help_tags()
    -- 			end,
    -- 			desc = "Lists available help tags and opens a new window with the relevant help info on <cr>",
    -- 		},
    -- 		{
    -- 			";;",
    -- 			function()
    -- 				local builtin = require("telescope.builtin")
    -- 				builtin.resume()
    -- 			end,
    -- 			desc = "Resume the previous telescope picker",
    -- 		},
    -- 		{
    -- 			";e",
    -- 			function()
    -- 				local builtin = require("telescope.builtin")
    -- 				builtin.diagnostics()
    -- 			end,
    -- 			desc = "Lists Diagnostics for all open buffers or a specific buffer",
    -- 		},
    -- 		{
    -- 			";s",
    -- 			function()
    -- 				local builtin = require("telescope.builtin")
    -- 				builtin.treesitter()
    -- 			end,
    -- 			desc = "Lists Function names, variables, from Treesitter",
    -- 		},
    -- 		{
    --
    -- 			"sf",
    -- 			function()
    -- 				local telescope = require("telescope")
    --
    -- 				local function telescope_buffer_dir()
    -- 					return vim.fn.expand("%:p:h")
    -- 				end
    --
    -- 				telescope.extensions.file_browser.file_browser({
    -- 					path = "%:p:h",
    -- 					cwd = telescope_buffer_dir(),
    -- 					respect_gitignore = false,
    -- 					hidden = true,
    -- 					grouped = true,
    -- 					previewer = false,
    -- 					initial_mode = "normal",
    -- 					layout_config = { height = 40 },
    -- 				})
    -- 			end,
    -- 			desc = "Open File Browser with the path of the current buffer",
    -- 		},
    -- 	},
    config = function()
      local status_ok, telescope = pcall(require, "telescope")
      if not status_ok then
        return
      end
      local actions = require("telescope.actions")
      -- local builtin = require("telescope.builtin")
      telescope.setup({
        defaults = {
          prompt_prefix = "🔎 ",
          selection_caret = " ",
          path_display = { "smart" },
          file_ignore_patterns = {
            ".git/",
            "target/",
            "docs/",
            "vendor/*",
            "%.lock",
            "__pycache__/*",
            "%.sqlite3",
            "%.ipynb",
            "node_modules/*",
            -- "%.jpg",
            -- "%.jpeg",
            -- "%.png",
            "%.svg",
            "%.otf",
            "%.ttf",
            "%.webp",
            ".dart_tool/",
            ".github/",
            ".gradle/",
            ".idea/",
            ".settings/",
            ".vscode/",
            "__pycache__/",
            "build/",
            "env/",
            "gradle/",
            "node_modules/",
            "%.pdb",
            "%.dll",
            "%.class",
            "%.exe",
            "%.cache",
            "%.ico",
            "%.pdf",
            "%.dylib",
            "%.jar",
            "%.docx",
            "%.met",
            "smalljre_*/*",
            ".vale/",
            "%.burp",
            "%.mp4",
            "%.mkv",
            "%.rar",
            "%.zip",
            "%.7z",
            "%.tar",
            "%.bz2",
            "%.epub",
            "%.flac",
            "%.tar.gz",
          },

          mappings = {
            n = {
              ["q"] = actions.close,
              ["dd"] = require("telescope.actions").delete_buffer,
              ["?"] = actions.which_key,
            },
          },
        },
        pickers = {
          live_grep = {
            theme = "dropdown",
            previewer = true,
          },
          grep_string = {
            theme = "dropdown",
          },
          find_files = {
            theme = "dropdown",
            previewer = true,
          },
          oldfiles = {
            theme = "dropdown",
            previewer = true,
          },

          buffers = {
            theme = "dropdown",
            previewer = false,
            initial_mode = "normal",
          },
          planets = {
            show_pluto = true,
            show_moon = true,
          },
          colorscheme = {
            -- enable_preview = true,
          },
          lsp_references = {
            theme = "dropdown",
            initial_mode = "normal",
          },
          lsp_definitions = {
            theme = "dropdown",
            initial_mode = "normal",
          },
          lsp_declarations = {
            theme = "dropdown",
            initial_mode = "normal",
          },
          lsp_implementations = {
            theme = "dropdown",
            initial_mode = "normal",
          },
        },
        extensions = {
          media_files = {
            filetypes = { "png", "webp", "jpg", "jpeg" },
            find_cmd = "rg", -- find command (defaults to `fd`)
          },
          file_browser = {
            theme = "dropdown",
            hijack_netrw = true,
            prompt_prefix = "🔎 ",
            mappings = {
              ["i"] = {
                ["<C-w>"] = function()
                  vim.cmd("normal vbd")
                end,
              },
            },
          },
          ["ui-select"] = {
            require("telescope.themes").get_cursor({
              -- even more opts
            }),
          },
        },
      })
    end,
  },
}
