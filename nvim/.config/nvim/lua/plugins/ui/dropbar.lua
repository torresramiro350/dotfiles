return {
	"Bekaboo/dropbar.nvim",
	event = { "BufRead", "BufReadPre", "BufNewFile" },
	opts = {},
	config = function(_, opts)
		local dropbar_api = require("dropbar.api")
	end,
}
