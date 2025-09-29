return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	enabled = true,
	opts = {
		auto_integrations = false, -- let capptuccin handle integrations
		background = { light = "latte", dark = "mocha" },
		float = { transparent = false, solid = false },
		flavour = "auto",
		dim_inactive = { enabled = false, shade = "dark", percentage = 0.15 },
		term_colors = true,
		no_italic = false,
		no_bold = false,
		styles = {
			comments = { "italic" },
			conditionals = { "italic" },
		},
		integrations = {
			blink_cmp = { enabled = true, style = "bordered" },
			cmp = true,
			diffview = true,
			dap = true,
			fzf = true,
			flash = true,
			fidget = true,
			gitsigns = true,
			gitgutter = true,
			lsp_trouble = true,
			headlines = true,
			markdown = true,
			render_markdown = true,
			mason = true,
			mini = { enabled = true },
			lsp_styles = {
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
					ok = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
					ok = { "underline" },
				},
				inlay_hints = { background = false },
			},
			noice = true,
			neotree = true,
			neogit = true,
			nvim_surround = true,
			notify = true,
			octo = true,
			snacks = { enabled = true, indent_scope_color = "lavender" },
			treesitter = true,
			treesitter_context = true,
			ts_rainbow = true,
			which_key = true,
			ufo = true,
		},
		highlight_overrides = {
			mocha = function(mocha)
				return { LineNr = { fg = mocha.overlay0 }, CursorLineNr = { fg = mocha.mauve } }
			end,
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin")
	end,
}
