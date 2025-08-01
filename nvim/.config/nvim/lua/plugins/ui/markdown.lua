return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		enabled = true,
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
		ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
		opts = {
			pipe_table = { preset = "round" },
			-- bulled = { enabled = true },
			heading = {
				sign = false,
				icons = { "󰼏 ", "󰎨 " },
				border = true,
				min_width = 90,
				width = "block",
			},
			checkbox = {
				enabled = false,
			},
			code = {
				sign = false,
				width = "block",
				right_pad = 1,
			},
			completions = {
				-- leaving this as disabled (since it breaks functionality with blink)
				-- blink = { enabled = true },
				lsp = { enabled = true },
				-- the code below seems to work
			},
		},
		config = function(_, opts)
			local render = require("render-markdown")
			render.setup(opts)
			Snacks.toggle({
				name = "Render Markdown",
				get = function()
					return require("render-markdown.state").enabled
				end,
				set = function(enabled)
					local m = require("render-markdown")
					if enabled then
						m.enable()
					else
						m.disable()
					end
				end,
			}):map("<leader>um")
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = "markdown",
		build = function()
			require("lazy").load({ plugins = { "markdown-preview.nvim" } })
			vim.fn["mkdp#util#install"]()
		end,
		keys = {
			{
				"<leader>cp",
				ft = "markdown",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "Markdown Preview",
			},
		},
		config = function()
			vim.cmd([[do FileType]])
		end,
	},
}
