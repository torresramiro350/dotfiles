local Lsp = require("utils.lsp")
return {
	cmd = { "neocmakelsp", "--stdio" },
	on_attach = Lsp.on_attach,
	filetypes = { "cmake" },
	root_markers = { ".git", "build", "cmake" },
}
