local Lsp = require("utils.lsp")

return {
	on_attach = Lsp.on_attach,
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	cmd_env = { RUFF_TRACE = "messages" },
	init_options = {
		settings = {
			organizeImport = true,
			lineLength = 88,
			logLevel = "error",
		},
	},
	settings = { format = { ["quote-style"] = "double" } },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
}
