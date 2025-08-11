local Lsp = require("utils.lsp")
return {
	filetypes = { "python" },
	cmd = { "basedpyright-langserver", "--stdio" },
	on_attach = Lsp.on_attach,
	settings = {
		basedpyright = {
			analysis = {
				autoSearchPaths = true,
				typeCheckingMode = "strict",
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
				inlayHints = {
					callArgumentNames = true,
				},
			},
		},
	},
}
