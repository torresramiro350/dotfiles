return {
	"HiPhish/rainbow-delimiters.nvim",
	enabled = false,
	event = { "BufRead" },
	opts = {},
	config = function(_, opts)
		require("rainbow-delimiters.setup").setup(opts)
	end,
}
