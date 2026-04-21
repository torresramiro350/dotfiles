return {
	"rose-pine/neovim",
	name = "rose-pine",
	opts = {
		variant = "auto",
		dark_variant = "main",
	},
	config = function()
		vim.cmd("colorscheme rose-pine")
	end,
}
