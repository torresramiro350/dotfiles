local Lsp = require("utils.lsp")
return {
	cmd = { "docker-langserver", "--stdio" },
	on_attach = Lsp.on_attach,
	filetypes = { "dockerfile" },
	root_markers = { "Dockerfile" },
}
