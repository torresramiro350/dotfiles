return {
	"jeangiraldoo/codedocs.nvim",
	keys = {
		{
			"<leader>cn",
			function()
				require("codedocs").generate()
			end,
		},
	},
	opts = {
		languages = {
			python = {
				filetypes = { "python" },
				default_style = "reST",
				styles = {
					reST = {
						default_annot = "comment",
						annots = {
							func = {},
							class = {},
							comment = {},
						},
					},
				},
			},
			c = {
				filetypes = { "c", "cpp" },
				default_style = "doxygen",
			},
		},
	},
	config = function(_, opts)
		require("codedocs").setup(opts)
	end,
}
