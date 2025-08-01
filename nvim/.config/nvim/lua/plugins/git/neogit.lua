require("groups.utility_funcs")
return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
		"ibhagwan/fzf-lua", -- optional
	},
	opts = {},
	config = function(_, opts)
		require("neogit").setup(opts)
	end,
	-- event = "VeryLazy",
	event = { "BufReadPre", "BufReadPost" },
	cond = in_git(),
}
