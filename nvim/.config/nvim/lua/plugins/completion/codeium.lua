require("groups.utility_funcs")
return {
	"Exafunction/windsurf.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	enabled = true,
	event = { "InsertEnter" },
	build = ":Codeium Auth",
	cmd = "Codeium",
	opts = {
		enable_cmp_source = vim.g.ai_cmp,
		virtual_text = {
			enabled = not vim.g.ai_cmp, -- handled by nvim-cmp / blink.cmp
			key_bindings = {
				accept = false, -- handled by nvim-cmp / blink.cmp
				next = "<M-]>",
				prev = "<M-[>",
			},
		},
	},
	config = function(_, opts)
		require("codeium").setup(opts)
	end,
}
