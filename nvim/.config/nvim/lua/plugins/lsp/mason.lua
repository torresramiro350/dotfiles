return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		event = "VeryLazy",
		opts_extended = {
			"ensure_installed",
		},
		opts = {
			ensure_installed = {
				"stylua",
				"clangd",
				"clang-format",
				"bash-language-server",
				"shellharden",
				"beautysh",
				"docker-language-server",
				"cmake-language-server",
				"cmakelint",
				"gersemi",
				"markdownlint-cli2",
				"markdown-toc",
				"markdown-oxide",
				"taplo",
				"pyproject-fmt",
				"yaml-language-server",
				"yamllint",
				"yamlfmt",
				"json-lsp",
				"prettier",
				"prettierd",
			},
		},
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)
			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},
}
