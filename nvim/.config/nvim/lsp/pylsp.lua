local Lsp = require("utils.lsp")
return {
	filetypes = { "python" },
	cmd = { "pylsp" },
	settings = {
		pylsp = {
			plugins = {
				pylint = { enabled = true },
				pycodestyle = { enabled = false },
				pyflakes = { enabled = false },
				autopep8 = { enabled = false },
				flake8 = { enabled = false },
				pylsp_isort = { enabled = false },
				pylsp_black = { enabled = false },
				pylsp_mypy = { enabled = false },
				mccabe = { enabled = false },
				yapf = { enabled = false },
			},
			signature = { formatter = "ruff" },
		},
	},
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
}
