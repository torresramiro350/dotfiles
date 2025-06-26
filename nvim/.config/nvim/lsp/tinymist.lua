Lsp = require("utils.lsp")
return {
	cmd = { "tinymist" },
	filetypes = { "typst" },
	on_attach = Lsp.on_attach,
}
