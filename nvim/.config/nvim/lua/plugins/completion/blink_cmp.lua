return {
	"saghen/blink.cmp",
	enabled = false,
	event = { "InsertEnter" },
	-- event = { "LspAttach" },
	dependencies = "rafamadriz/friendly-snippets",
	nerd_font_variant = "normal",
	version = "v0.*",
	opts = {
		accept = { auto_brackets = { enable = true } },
		highlight = {
			use_nvim_cmp_as_default = true,
		},
		keymap = {
			show = "<C-e>",
			hide = "<C-d>",
			accept = "<cr>",
			select_prev = { "<Up>", "<C-p>" },
			select_next = { "<Down>", "<C-n>" },

			show_documentation = "<C-space>",
			hide_documentation = "<C-space>",
			scroll_documentation_up = "<C-b>",
			scroll_documentation_down = "<C-f>",
			snippet_forward = "<C-l>",
			snippet_backward = "<C-h>",
		},
		windows = {
			autocomplete = {
				min_width = 15,
				max_height = 10,
				border = "single",
				winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
				cycle = {
					from_bottom = true,
					from_top = true,
				},
				draw = "simple",
			},
			documentation = {
				min_width = 10,
				max_width = 60,
				max_height = 20,
				border = "padded",
			},
			signature_help = {
				min_width = 1,
				max_width = 100,
				max_height = 10,
				border = "padded",
				winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
			},
		},
		sources = {},
	},
}
