return {
	"okuuva/auto-save.nvim",
	cmd = "ASToggle",
	event = { "InsertLeave", "TextChanged" },
	opts = {},
	config = function(_, opts)
		require("auto-save").setup(opts)
	end,
}
