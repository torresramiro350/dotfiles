local Lsp = require("utils.lsp")
return {
	filetypes = { "lua" },
	on_attach = Lsp.on_attach,
	cmd = { "lua-language-server" },
	settings = {
		Lua = {
			diagnositcs = {
				global = { "vim" },
			},
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths
					-- here.
					-- '${3rd}/luv/library'
					-- '${3rd}/busted/library'
				},
			},
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
	},
}
