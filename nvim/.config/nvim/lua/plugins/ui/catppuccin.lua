return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		background = {
			light = "latte",
			dark = "mocha",
		},
		float = { transparent = false, solid = false },
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
			harpoon = true,
			headlines = true,
			markdown = true,
			markview = true,
			render_markdown = true,
			mason = true,
			mini = {
				enabled = true,
			},
			native_lsp = {
				enabled = true,
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
				inlay_hints = {
					-- don't want a background for the inlay hints
					background = false,
				},
			},
			noice = true,
			neotree = true,
			neogit = true,
			nvim_surround = true,
			notify = true,
			octo = true,
			snacks = { enabled = true, picker_style = "nvchad_outlined" },
			telescope = {
				enabled = true,
			},
			treesitter = true,
			treesitter_context = true,
			ts_rainbow = true,
			which_key = true,
			ufo = true,
		},
		highlight_overrides = {
			mocha = function(mocha)
				-- return { LineNr = { fg = mocha.lavender } }
				return { LineNr = { fg = mocha.overlay0 } }
			end,
		},
	},
}
