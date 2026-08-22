return {
	"OXY2DEV/markview.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
		"saghen/blink.cmp",
	},
	lazy = false,
	priority = 49,
	enabled = true,
	keys = {
		{ "<leader>cp", "<cmd>Markview toggle<cr>", desc = "Toggle markdown preview" },
	},
	opts = {
		preview = {
			enable = true,
			enable_hybrid_mode = true,
			filetypes = { "markdown", "quarto", "rmd", "typst" },
			ignore_buftypes = { "nofile" },
			icon_provider = "mini",
			debounce = 50,
			linewise_hybrid_mode = false,
			hybrid_modes = { "n", "i" },
			-- modes = { "n", "no", "c" },
			max_buf_lines = 500,
		},
		markdown = {
			enable = true,
			headings = { enable = true, shift_width = 1 },
			code_blocks = {
				enable = true,
				border_hl = "MarkviewCode",
				info_hl = "MarkviewCodeInfo",
				label_direction = "right",
				label_hl = nil,
				min_width = 100,
				pad_amount = 2,
				pad_char = " ",
				default = { block_hl = "MarkviewCode", pad_hl = "MarkviewCode" },
				["diff"] = {
					block_hl = function(_, line)
						if line:match("^%+") then
							return "MarkviewPalette4"
						elseif line:match("^%-") then
							return "MarkviewPalette1"
						else
							return "MarkviewCode"
						end
					end,
					pad_hl = "MarkviewCode",
				},
				sign = true,
				-- style = "block",
				style = function(buf)
					if vim.o.wrap then
						return "simple"
					end
					local win = require("markview.utils").buf_getwin(buf)
					return vim.wo[win].wrap == true and "simple" or "block"
				end,
			},
			block_quotes = { enable = true, default = { border = "▋" } },
			list_items = { enable = true, indent_size = 2, shift_width = 2, marker_minus = { text = "" } },
			tables = { enable = true, use_virt_lines = false, style = "rounded" },
		},
		markdown_inline = {
			enable = true,
			internal_links = { enable = true },
			embed_files = { enable = true },
			hyperlinks = { enable = true },
			footnotes = { enable = true },
			inline_codes = { enable = true },
			checkboxes = {
				enable = true,
				checked = { text = "✔" },
				unchecked = { text = "✘" },
			},
		},
		html = { enable = true },
		latex = { enable = true },
		yaml = { enable = true },
	},
	config = function(_, opts)
		require("markview").setup(opts)
	end,
}
