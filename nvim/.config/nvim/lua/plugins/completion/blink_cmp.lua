return {
	"saghen/blink.cmp",
	dependencies = {
		"echasnovski/mini.snippets",
		-- "rafamadriz/friendly-snippets",
		"Exafunction/codeium.nvim",
		{
			"Kaiser-Yang/blink-cmp-dictionary",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{ "saghen/blink.compat", opts = {}, version = "*" },
	},
	event = "InsertEnter",
	enabled = true,
	version = "*",
	opts_extend = {
		"sources.completion.enabled_providers",
		"sources.compat",
		"sources.default",
	},
	opts = {
		snippets = {
			preset = "mini_snippets",
		},
		appearance = {
			use_nvim_cmp_as_default = false,
			nerd_font_variant = "normal",
		},
		completion = {
			ghost_text = {
				enabled = vim.g.ai_cmp,
			},
			menu = {
				-- don't show completion when searching
				auto_show = function(ctx)
					return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
				end,
				draw = {
					treesitter = { "lsp" },
					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
								return kind_icon
							end,
							-- (optional) use highlights from mini.icons
							highlight = function(ctx)
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
						kind = {
							-- (optional) use highlights from mini.icons
							highlight = function(ctx)
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
					},
				},
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
			window = {
				show_documentation = false,
			},
			enabled = false,
		},
		cmdline = {
			enabled = true,
			sources = function()
				local type = vim.fn.getcmdtype()
				-- Search forward and backward
				if type == "/" or type == "?" then
					return { "buffer" }
				end
				-- Commands
				if type == ":" or type == "@" then
					return { "cmdline" }
				end
				return {}
			end,
		},
		sources = {
			default = function(ctx)
				local filetype = vim.bo.filetype
				local defaults = { "lsp", "path", "snippets", "buffer" }
				-- Filetype-specific completions
				local filetype_completions = {
					lua = { "lazydev", "codeium" },
					-- markdown = { "markdown", "dictionary" },
					markdown = { "dictionary" },
					text = { "markdown", "dictionary" },
				}
				-- Check for filetype matches first
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
					return { "buffer" }
				end
				-- Default case
				table.insert(defaults, "codeium")
				return defaults
			end,
			-- compat = { "codeium" },
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
					score_offset = 100, -- show at a higher priority than lsp
				},
				codeium = {
					name = "codeium",
					-- kind = "Codeium",
					module = "blink.compat.source",
					score_offset = 100,
					async = true,
				},
			},
			-- cmdline = function() end,
		},
		keymap = {
			preset = "default",
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
