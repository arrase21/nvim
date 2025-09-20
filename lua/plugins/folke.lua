return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			quickfile = { enabled = true },
			win = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			toggle = { map = vim.safe_keymap_set },
			words = { enabled = true },
			explorer = { enabled = true },
			input = { enabled = true },
			statuscolumn = { enabled = true },
			bigfile = { enabled = true },
			picker = { enabled = false },
			indent = { enabled = true },
			notifier = { enabled = true },
			notify = { enabled = true },
			dashboard = {
				example = "compact_files",
				preset = {
					header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
				},
			},
		},
	},
}
