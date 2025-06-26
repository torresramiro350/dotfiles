Lsp = require("utils.lsp")
return {
	cmd = { "markdown-oxide" },
	filetypes = { "markdown" },
	on_attach = Lsp.on_attach,
}
