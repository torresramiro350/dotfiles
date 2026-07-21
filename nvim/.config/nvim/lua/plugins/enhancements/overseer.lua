return {
	"stevearc/overseer.nvim",
	opts = {
		templates = { "builtin" },
	},
	config = function(_, opts)
		require("overseer").setup(opts)
	end,
}
