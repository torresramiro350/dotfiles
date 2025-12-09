-- Documentation for basedpyright settings is here: https://docs.basedpyright.com/latest/configuration/language-server-settings/
-- for more information of these settings
return {
	filetypes = { "python" },
	cmd = { "basedpyright-langserver", "--stdio" },
	settings = {
		basedpyright = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				autoFormatStrings = true,
				inlayHints = {
					callArgumentNamesMatching = true,
					functionReturnTypes = true,
					callArgumentNames = true,
					variableTypes = false,
				},
			},
		},
	},
}
