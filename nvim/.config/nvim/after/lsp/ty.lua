return {
	settings = {
		ty = {
			inlayHints = { variableTypes = false, callArgumentNames = true },
			completions = { autoImport = true },
			diagnosticMode = "openFilesOnly",
			completeFunctionParentheses = true,
		},
	},
	filetypes = { "python" },
	cmd = { "ty", "server" },
	root_markers = { "ty.toml", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
}
