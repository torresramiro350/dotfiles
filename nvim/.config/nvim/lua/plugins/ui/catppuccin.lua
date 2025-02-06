return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = true,
	opts = {
		background = {
			light = "latte",
			dark = "mocha",
		},
		flavour = "auto",
		dim_inactive = {
			enabled = false,
			shade = "dark",
			percentage = 0.15,
		},
		term_colors = true,
		no_italic = false,
		styles = {
			comments = { "italic" },
			conditionals = { "italic" },
			loops = { "italic" },
			functions = { "italic" },
			keywords = { "italic" },
			types = { "italic" },
			properties = { "italic" },
		},
		integrations = {
			--defaults
			blink_cmp = true,
			cmp = true,
			diffview = true,
			dap = true,
			fzf = true,
			flash = true,
			fidget = true,
			gitsigns = true,
			gitgutter = true,
			lsp_trouble = true,
			harpoon = true,
			headlines = true,
			markdown = true,
			render_markdown = true,
			mason = true,
			mini = {
				enabled = true,
			},
			native_lsp = {
				enabled = true,
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
					ok = { "undercurl" },
				},
				inlay_hints = {
					background = true,
				},
			},
			noice = true,
			neotree = true,
			neogit = true,
			nvim_surround = true,
			notify = true,
			octo = true,
			snacks = true,
			telescope = {
				enabled = true,
			},
			treesitter = true,
			treesitter_context = true,
			ts_rainbow = true,
			which_key = true,
			ufo = true,
		},
		color_overrides = {
			mocha = {
				-- base = "#1e1e2e",
				-- base = "#181825",
			},
		},
		highlight_overrides = {
			mocha = function(mocha)
				-- return { LineNr = { fg = mocha.lavender } }
				return { LineNr = { fg = mocha.overlay0 } }
			end,
		},
	},
}
