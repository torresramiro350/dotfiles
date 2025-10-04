return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		version = false,
		enabled = true,
		lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
		build = function()
			local TS = require("nvim-treesitter")
			TS.update(nil, { summary = true })
		end,
		event = { "VeryLazy" },
		cmd = { "TSUpdateSync", "TSUpdate", "TSLog", "TSInstall" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		keys = {
			{ "<c-space>", desc = "Increment Selection" },
			{ "<bs>", desc = "Decrement Selection", mode = "x" },
		},
		opts_extended = { "ensure_installed" },
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			folds = { enable = true },
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
		},
		config = function(_, opts)
			-- require("nvim-treesitter.configs").setup(opts)
			local TS = require("nvim-treesitter")
			TS.setup(opts)
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("my_nvim_treesitter", { clear = true }),
				callback = function()
					if vim.tbl_get(opts, "highlight", "enable") ~= false then
						pcall(vim.treesitter.start)
					end
				end,
			})
		end,
	},
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
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = "VeryLazy",
		opts = {},
		keys = function()
			local moves = {
				goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
				goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
				goto_previous_start = {
					["[f"] = "@function.outer",
					["[c"] = "@class.outer",
					["[a"] = "@parameter.inner",
				},
				goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
			}
			local ret = {} ---@type LazyKeysSpec[]
			for method, keymaps in pairs(moves) do
				for key, query in pairs(keymaps) do
					local desc = query:gsub("@", ""):gsub("%..*", "")
					desc = desc:sub(1, 1):upper() .. desc:sub(2)
					desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
					desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
					ret[#ret + 1] = {
						key,
						function()
							-- don't use treesitter if in diff mode and the key is one of the c/C keys
							if vim.wo.diff and key:find("[cC]") then
								return vim.cmd("normal! " .. key)
							end
							require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
						end,
						desc = desc,
						mode = { "n", "x", "o" },
						silent = true,
					}
				end
			end
			return ret
		end,
		config = function(_, opts)
			local TS = require("nvim-treesitter-textobjects")
			if not TS.setup then
				error("Please use `:Lazy` and update `nvim-treesitter`", 0)
				return
			end
			TS.setup(opts)
		end,
	},
}
