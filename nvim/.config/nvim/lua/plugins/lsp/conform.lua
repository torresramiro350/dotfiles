return {
	"stevearc/conform.nvim",
	-- event = { "BufReadPost", "BufNewFile" },
	event = { "BufWritePre" },
	command = { "ConformInfo" },
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters = {
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
					end,
				},
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))
						return #diag > 0
					end,
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				yaml = { "yamlfmt" },
				json = { "prettierd", "prettier" },
				markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
				cmake = { "cmake_format" },
				python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
				sh = { "shfmt", "shellharden" },
				toml = { "taplo" },
				tex = { "latexindent" },
			},
			format_on_save = {
				timeout_ms = 3000,
				async = false, -- not recommended to change
				quiet = false, -- not recommended to change
				lsp_format = "fallback", -- not recommended to change
			},
		})
	end,
}
