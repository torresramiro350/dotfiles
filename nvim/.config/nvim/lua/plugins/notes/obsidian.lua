return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ibhagwan/fzf-lua",
	},
	opts = {
		-- disabling this in favor of the ui from render markdown as they might not play ncie
		-- with eachother:
		-- https://github.com/MeanderingProgrammer/render-markdown.nvim
		ui = { enable = false },
		legacy_commands = false,
		workspaces = {
			{
				name = "work",
				path = "~/Documents/vaults/science-notes",
			},
			{
				name = "personal",
				path = "~/Documents/vaults/personal",
			},
		},
		picker = {
			name = "snacks.pick",
		},
		completion = {
			-- Set to false to disable completion.
			nvim_cmp = false,
			blink = true,
			-- Trigger completion at 2 chars.
			min_chars = 2,
			create_new = true,
		},
	},
}
