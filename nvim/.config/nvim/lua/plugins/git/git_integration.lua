-- Git integration plugins placed here
require("groups.utility_funcs")
return {
	{
		"tpope/vim-rhubarb",
		event = { "BufReadPre", "BufReadPost" },
		-- priority = 1000,
		cond = in_git(),
	},
	-- allows the integration of git functionality within neovim
	{
		"tpope/vim-fugitive",
		-- event = { "BufRead", "BufReadPost" },
		event = { "BufReadPre", "BufReadPost" },
		-- priority = 1000,
		cond = in_git(),
	},
	{
		-- priority = 1000,
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		-- event = { "BufRead", "BufReadPost" },
		event = { "BufReadPre", "BufReadPost" },
		cond = in_git(),
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "|" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
				local next_hunk_repeat, prev_hunk_repeat =
					ts_repeat_move.make_repeatable_move_pair(gitsigns.next_hunk, gitsigns.prev_hunk)

				nmap({ "n", "x", "o" }, "]h", next_hunk_repeat)
				nmap({ "n", "x", "o" }, "[h", prev_hunk_repeat)

				nmap("n", "<leader>td", gitsigns.toggle_deleted, { desc = "[T]oggle deleted lines" })
				nmap("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
				nmap("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" })

				nmap("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
				nmap("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
				nmap("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
				nmap("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
				nmap("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "git [u]ndo stage hunk" })
				nmap("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
				nmap("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" })
				nmap("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })
				nmap("n", "<leader>hD", function()
					gitsigns.diffthis("@")
				end, { desc = "git [D]iff against last commit" })
				-- Toggles

				-- don't override the built-in and fugitive keymaps
				local gs = package.loaded.gitsigns
				nmap({ "n", "v" }, "]h", function()
					if vim.wo.diff then
						return "]h"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
				nmap({ "n", "v" }, "[h", function()
					if vim.wo.diff then
						return "[h"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
			end,
		},
	},
}
