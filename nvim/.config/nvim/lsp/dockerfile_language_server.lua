local Lsp = require("utils.lsp")
return {
	cmd = { "docker-compose-langserver", "--stdio" },
	on_attach = Lsp.on_attach,
	filetypes = { "yaml.docker-compose" },
	root_markers = { "docker-compose.yaml", "docker-compose.yml", "compose.yaml", "compose.yml" },
}
