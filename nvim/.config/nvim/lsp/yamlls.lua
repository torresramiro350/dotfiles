local Lsp = require("utils.lsp")
return {
	on_attach = Lsp.on_attach,
	filetypes = { "yaml", "yml" },
	capabilities = {
		textDocument = {
			foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			},
		},
	},
	on_new_config = function(new_config)
		new_config.settings.yaml.schemas =
			vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
	end,
	settings = {
		redhat = { telemetry = { enabled = false } },
		yaml = {
			keyOrdering = false,
			format = { enable = true },
			validate = true,
			schemaStore = {
				enable = false,
				url = "",
			},
		},
	},
}
