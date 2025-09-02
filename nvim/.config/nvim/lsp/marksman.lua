local Lsp = require("utils.lsp")
return {
	filetypes = { "markdown", "markdown.mdx" },
	on_attach = Lsp.on_attach,
	cmd = { "marksman", "server" },
}
