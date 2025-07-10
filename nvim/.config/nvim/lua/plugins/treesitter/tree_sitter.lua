return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		opts = function()
			local tsc = require("treesitter-context")
			Snacks.toggle({
				name = "Treesitter context",
				get = tsc.enabled,
				set = function(state)
					if state then
						tsc.enable()
					else
						tsc.disable()
					end
				end,
			}):map("<leader>ut")
			return { mode = "cursor", max_lines = 3, multiline_threshold = 3 }
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufReadPost" },
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		keys = {
			{ "<c-space>", desc = "Increment Selection" },
			{ "<bs>", desc = "Decrement Selection", mode = "x" },
		},
		init = function(plugin)
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,
		opts_extended = { "ensure_installed" },
		opts = {
			highlight = { enable = true, additional_vim_regex_highlighting = true },
			indent = { enable = true },
			-- Add languages to be installed here that you want installed for treesitter
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"cmake",
				"go",
				"json",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"ninja",
				"rst",
				"python",
				"printf",
				"rust",
				"regex",
				"toml",
				"vim",
				"vimdoc",
				"yaml",
			},
			auto_install = true,
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			textobjects = {
				select = {
					enable = false,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["iC"] = "@class.inner",
						["ic"] = "@comment.inner",
						["oc"] = "@comment.outer",
						["aF"] = "@custom.capture",
					},
				},
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "<c-v>", -- blockwise
				},
				lsp_interop = {
					enable = true,
					border = "rounded",
					peek_definition_code = {
						["<leader>df"] = "@function.outer",
						["<leader>dF"] = "@class.outer",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
						["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
						["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
					},
					goto_next_end = {
						["]F"] = "@function.outer",
						["]C"] = "@class.outer",
						["]A"] = "@parameter.outer",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
						["[A"] = "@parameter.inner",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
