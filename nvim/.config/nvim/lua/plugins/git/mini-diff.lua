return {
	"echasnovski/mini.diff",
	event = "VeryLazy",
	-- disabling for now, as it doesn't offer the same level of functionality as
	-- gitsigns. Might delete later.
	enabled = false,
	cond = in_git(),
	keys = {
		{
			"<leader>go",
			function()
				require("mini.diff").toggle_overlay(0)
			end,
			desc = "Toggle mini.diff overlay",
		},
	},
	opts = function()
		-- NOTE: taken from LazyVim's config
		Snacks.toggle({
			name = "Mini Diff Signs",
			get = function()
				return vim.g.minidiff_disable ~= true
			end,
			set = function(state)
				vim.g.minidiff_disable = not state
				if state then
					require("mini.diff").enable(0)
				else
					require("mini.diff").disable(0)
				end
				-- HACK: redraw to update the signs
				vim.defer_fn(function()
					vim.cmd([[redraw!]])
				end, 200)
			end,
		}):map("<leader>uG")
		local opts = {
			mappings = {
				reset = "<leader>ghr",
				apply = "<leader>ghs",
				textobject = "gh",
				goto_first = "[H",
				goto_prev = "[h",
				goto_next = "]h",
				goto_last = "]H",
			},
			view = {
				style = "sign",
				signs = {
					add = "▎",
					change = "▎",
					delete = "",
				},
			},
		}
		return opts
	end,
	config = function(_, opts)
		require("mini.diff").setup(opts)
	end,
}
