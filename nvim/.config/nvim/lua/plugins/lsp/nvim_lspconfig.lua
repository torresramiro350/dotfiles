return {

	-- LSP Configuration & Plugins
	"neovim/nvim-lspconfig",
	enabled = true,
	event = { "BufNewFile", "BufReadPre", "BufReadPost" },
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{ "williamboman/mason.nvim", opts = {} },
		{ "williamboman/mason-lspconfig.nvim", config = function() end },
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "saghen/blink.cmp" },
	},
}
