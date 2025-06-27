local Lsp = require("utils.lsp")
return {
	filetypes = { "markdown" },
	on_attach = Lsp.on_attach,
	cmd = { "markdown-oxide" },
}
