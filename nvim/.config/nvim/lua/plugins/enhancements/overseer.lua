return {
	"stevearc/overseer.nvim",
	event = { "VeryLazy" },
	opts = {
		templates = { "builtin" },
	},
	config = function(_, opts)
		require("overseer").setup(opts)
	end,
}
