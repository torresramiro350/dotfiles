local Lsp = require("utils.lsp")
return {
	filetypes = { "python" },
	cmd = { "ty", "server" },
	on_attach = Lsp.on_attach,
	root_markers = { "ty.toml", "pyproject.toml", ".git" },
}
