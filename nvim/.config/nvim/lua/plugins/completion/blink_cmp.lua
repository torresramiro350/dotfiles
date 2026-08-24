local function get_mini_icon(ctx)
	if ctx.source_name == "Path" then
		local is_unknown_type =
			vim.tbl_contains({ "link", "socket", "fifo", "char", "block", "unknown" }, ctx.item.data.type)
		local mini_icon, mini_hl, _ = require("mini.icons").get(
			is_unknown_type and "os" or ctx.item.data.type,
			is_unknown_type and "" or ctx.label
		)
		if mini_icon then
			return mini_icon, mini_hl
		end
	end
	local mini_icon, mini_hl, _ = require("mini.icons").get("lsp", ctx.kind)
	return mini_icon, mini_hl
end

return {
	"saghen/blink.cmp",

	dependencies = {
		"saghen/blink.lib",
		"echasnovski/mini.snippets",
		"onsails/lspkind.nvim",
		{ "Kaiser-Yang/blink-cmp-dictionary", dependencies = { "nvim-lua/plenary.nvim" } },
		{ "saghen/blink.compat", opts = {}, version = "*" },
	},
	build = function()
		require("blink.cmp").build():pwait()
	end,
	event = { "InsertEnter", "CmdlineEnter" },
	enabled = true,
	opts_extend = {
		"sources.completion.enabled_providers",
		"sources.compat",
		"sources.default",
	},
	opts = {
		fuzzy = { implementation = "prefer_rust_with_warning" },
		snippets = { preset = "mini_snippets" },
		appearance = { nerd_font_variant = "normal" },
		completion = {
			accept = { auto_brackets = { enabled = true } },
			list = {
				selection = {
					preselect = function(ctx)
						return not require("blink.cmp").snippet_active({ direction = 1 })
					end,
					auto_insert = function(ctx)
						return vim.bo.filetype ~= "markdown"
					end,
				},
			},
			ghost_text = { enabled = true },
			menu = {
				draw = {
					columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
					components = {
						kind_icon = {
							text = function(ctx)
								local kind_icon, kind_hl = get_mini_icon(ctx)
								return " " .. kind_icon .. ctx.icon_gap .. " "
							end,
							highlight = function(ctx)
								local _, hl = get_mini_icon(ctx)
								return hl
							end,
						},
						kind = {
							highlight = function(ctx)
								local _, hl = get_mini_icon(ctx)
								return hl
							end,
						},
					},
				},
				auto_show = function(ctx)
					return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
				end,

				border = "rounded",
			},
			documentation = {
				window = { border = "rounded" },
				auto_show = true,
				auto_show_delay_ms = 200,
				update_delay_ms = 50,
				treesitter_highlighting = true,
			},
		},
		signature = {
			window = { show_documentation = false },
			enabled = false,
		},
		cmdline = {
			keymap = { preset = "inherit" },
			completion = {
				ghost_text = { enabled = true },
				menu = {
					auto_show = function(ctx)
						return vim.fn.getcmdtype() == ":"
					end,
				},
			},
		},
		sources = {
			default = function(ctx)
				local filetype = vim.bo.filetype
				local defaults = { "lsp", "path", "snippets", "buffer" }
				local filetype_completions = {
					lua = { "lazydev" },
					markdown = { "dictionary" },
					tex = { "dictionary" },
				}
				if filetype_completions[filetype] then
					vim.list_extend(defaults, filetype_completions[filetype])
					return defaults
				end
				-- Check for comment nodes
				local success, node = pcall(vim.treesitter.get_node)
				local is_comment = success
					and node
					and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type())
				if is_comment then
					return { "buffer", "dictionary" }
				end
				return defaults
			end,
			providers = {
				dictionary = {
					module = "blink-cmp-dictionary",
					name = "Dict",
					max_items = 5,
					min_keyword_length = 3,
					opts = {
						dictionary_directories = { vim.fn.expand("~/.config/nvim/dictionary") },
					},
				},
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
				cmdline = {
					min_keyword_length = function(ctx)
						if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
							return 3
						end
						return 0
					end,
				},
			},
		},
		keymap = {
			preset = "enter",
			["<C-space>"] = {
				function(cmp)
					cmp.show({ providers = { "snippets" } })
				end,
			},
			["<C-y>"] = { "select_and_accept" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<Tab>"] = {
				function(cmp)
					if cmp.snippet_active() then
						return cmp.accept()
					else
						return cmp.select_and_accept()
					end
				end,
				"snippet_forward",
				"fallback",
			},
			["<S-Tab>"] = { "snippet_backward", "fallback" },
		},
	},
	config = function(_, opts)
		require("blink-cmp").setup(opts)
	end,
}
