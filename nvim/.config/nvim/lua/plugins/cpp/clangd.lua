return {
	"p00f/clangd_extensions.nvim",
	lazy = true,
	config = function() end,
	keys = {
		{ "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
	},
	opts = {
		inlay_hints = {
			inline = false,
		},
		ast = {
			--These require codicons (https://github.com/microsoft/vscode-codicons)
			role_icons = {
				type = "",
				declaration = "",
				expression = "",
				specifier = "",
				statement = "",
				["template argument"] = "",
			},
			kind_icons = {
				Compound = "",
				Recovery = "",
				TranslationUnit = "",
				PackExpansion = "",
				TemplateTypeParm = "",
				TemplateTemplateParm = "",
				TemplateParamObject = "",
			},
			highlights = {
				detail = "Comment",
			},
		},
	},
}
