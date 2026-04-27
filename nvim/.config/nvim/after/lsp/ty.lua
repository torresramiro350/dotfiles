return {
	settings = {
		ty = {
			inlayHints = { variableTypes = false },
			completions = { autoImport = true },
			diagnosticMode = "openFilesOnly",
		},
	},
	filetypes = { "python" },
	cmd = { "ty", "server" },
	root_markers = { "ty.toml", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
}
