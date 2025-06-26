return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	lazy = true,
	event = { "BufReadPre" },
	command = { "ConformInfo" },
	opts = function()
		local opts = {
			default_format_opts = {
				timeout_ms = 3000,
				async = false, -- not recommended to change
				quiet = false, -- not recommended to change
				lsp_format = "fallback", -- not recommended to change
			},
			format_on_save = { lsp_format = "fallback" },
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
				["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
				["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
				fish = { "fish_indent" },
				cmake = { "cmake_format" },
				python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
				sh = { "shfmt", "shellharden" },
				toml = { "taplo" },
				tex = { "latexindent" },
				typst = { "prettypst" },
			},
		}
		return opts
	end,
	config = function(_, opts)
		require("conform").setup(opts)
	end,
}
