return {
	"Bekaboo/dropbar.nvim",
	event = { "BufRead", "BufReadPre", "BufNewFile" },
  enabled = false,
	opts = {},
	config = function(_, opts)
		local dropbar_api = require("dropbar.api")
	end,
}
