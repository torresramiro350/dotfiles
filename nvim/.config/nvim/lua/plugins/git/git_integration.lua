-- Git integration plugins placed here
require("groups.utility_funcs")
return {
	{
		"tpope/vim-rhubarb",
		event = { "BufReadPre", "BufReadPost" },
		cond = in_git(),
	},
	-- allows the integration of git functionality within neovim
	{
		"tpope/vim-fugitive",
		event = { "BufReadPre", "BufReadPost" },
		cond = in_git(),
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufReadPost" },
		cond = in_git(),
		opts = function()
			return {
				current_line_blame = true,
				signs = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "" },
					topdelete = { text = "" },
					changedelete = { text = "▎" },
					untracked = { text = "▎" },
				},
				signs_staged = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "" },
					topdelete = { text = "" },
					changedelete = { text = "▎" },
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					-- local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
					-- local next_hunk_repeat, prev_hunk_repeat =
					-- 	ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
					--
					-- nmap({ "n", "x", "o" }, "]h", next_hunk_repeat)
					-- nmap({ "n", "x", "o" }, "[h", prev_hunk_repeat)
					nmap("n", "]h", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gs.nav_hunk("next")
						end
					end, { desc = "Next Hunk" })
					nmap("n", "[h", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gs.nav_hunk("prev")
						end
					end, { desc = "Prev Hunk" })

          -- stylua: ignore start
					nmap("n", "]H", function() gs.nav_hunk("last") end, { buffer = bufnr, desc = "Last Hunk" })
					nmap("n", "[H", function() gs.nav_hunk("first") end, { desc = "First Hunk" })
					-- nmap("n", "<leader>td", gs.toggle_deleted, { desc = "[T]oggle deleted lines" })
					-- nmap("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
					-- nmap("n", "<leader>tD", gs.toggle_deleted, { desc = "[T]oggle git show [D]eleted" })
					nmap("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview hunk line" })
					nmap("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage hunk" })
					nmap("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset hunk" })
					nmap("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage buffer" })
					nmap("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
					nmap("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset buffer" })
					nmap("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
					nmap("n", "<leader>ghB", function() gs.blame() end, { desc = "Blame Buffer" })
					nmap("n", "<leader>ghd", gs.diffthis, { desc = "Diff against index" })
					nmap("n", "<leader>ghD", function() gs.diffthis("@") end, { desc = "Diff against last commit" })
					nmap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "GitSigns Select Hunk" })
					-- stylua: ignore end
				end,
			}
		end,
		config = function(_, opts)
			-- local gitsigns = require("gitsigns")
			Snacks.toggle({
				name = "Git Signs",
				get = function()
					return require("gitsigns.config").config.signcolumn
				end,
				set = function(state)
					require("gitsigns").toggle_signs(state)
				end,
			}):map("<leader>uG")
			local gs = package.loaded.gitsigns
			gs.setup(opts)
		end,
	},
}
