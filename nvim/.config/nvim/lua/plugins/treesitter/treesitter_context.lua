return {
	"nvim-treesitter/nvim-treesitter-context",
	event = "VeryLazy",
	opts = function()
		local tsc = require("treesitter-context")
		Snacks.toggle({
			name = "Treesitter context",
			get = tsc.enabled,
			set = function(state)
				if state then
					tsc.enable()
				else
					tsc.disable()
				end
			end,
		}):map("<leader>ut")
		return { mode = "cursor", max_lines = 3, multiline_threshold = 3 }
	end,
}
