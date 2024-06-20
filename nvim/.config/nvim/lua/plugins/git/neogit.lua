require("groups.utility_funcs")
return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration

		-- Only one of these is needed, not both.
		"nvim-telescope/telescope.nvim", -- optional
		"ibhagwan/fzf-lua", -- optional
	},
	-- config = true,
	config = function()
		local neogit = require("neogit")
		neogit.setup({})
	end,
	-- event = "VeryLazy",
	event = { "BufReadPre", "BufReadPost" },
	cond = in_git(),
}
