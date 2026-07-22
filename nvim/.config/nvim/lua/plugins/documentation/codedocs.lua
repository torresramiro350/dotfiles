return {
	"jeangiraldoo/codedocs.nvim",
	event = { "BufReadPost", "BufNewFile" },
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
				-- filetypes = { "c", "cpp", "h", "hpp" },
				default_style = "Doxygen",
				styles = {
					Doxygen = {},
				},
			},
			bash = {
				filetypes = { "sh", "bash" },
				default_style = "Google",
				styles = {
					Google = {},
				},
			},
		},
	},
	config = function(_, opts)
		require("codedocs").setup(opts)
	end,
}
