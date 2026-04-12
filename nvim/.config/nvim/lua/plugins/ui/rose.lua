return {
	"rose-pine/neovim",
	name = "rose-pine",
	opts = {
		variant = "auto",
		dark_variant = "main",
	},
	config = function(opts)
		require("rose-pine").setup(opts)
		vim.cmd("colorscheme rose-pine")
	end,
}
