local Lsp = require("utils.lsp")
return {
	on_attach = Lsp.on_attach,
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	Lua = {
		workspace = { checkThirdParty = false },
		codeLens = { enable = true },
		completion = {
			callSnippet = "Replace",
		},
		doc = {
			privateName = { "^_" },
		},
		hint = {
			enable = true,
			setType = false,
			paramType = true,
			paramName = "Disable",
			semicolon = "Disable",
			arrayIndex = "Disable",
		},
	},
}
