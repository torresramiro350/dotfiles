local diagnostics = {
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = true },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	} or {},
	virtual_text = {
		prefix = "●",
		current_line = true,
		source = "if_many",
		spacing = 4,
		format = function(diagnostic)
			local diagnostic_message = {
				[vim.diagnostic.severity.ERROR] = diagnostic.message,
				[vim.diagnostic.severity.WARN] = diagnostic.message,
				[vim.diagnostic.severity.INFO] = diagnostic.message,
				[vim.diagnostic.severity.HINT] = diagnostic.message,
			}
			return diagnostic_message[diagnostic.severity]
		end,
	},
}

vim.diagnostic.config(diagnostics)

vim.lsp.enable({
	"lua_ls",
	"basedpyright", -- trying out pylsp for now
	-- "pylsp",
	"ruff",
	"bashls",
	"clangd",
	"yamlls",
	"jsonls",
	"neocmake",
	"markdown_oxide",
	"dockerls",
	"tinymist",
	"taplo",
})
