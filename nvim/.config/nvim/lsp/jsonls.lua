Lsp = require("utils.lsp")
return {
	filetypes = { "json", "jsonc" },
	cmd = { "vscode-json-language-server", "--stdio" },
	on_attach = Lsp.on_attach,
	init_options = { provideFormatter = true },
	root_markers = { ".git" },
}
