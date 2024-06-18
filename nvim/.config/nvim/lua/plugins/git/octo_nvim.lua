require("groups.utility_funcs")
return {
	priority = 1000,
	"pwntester/octo.nvim",
	-- event = "VeryLazy",
	event = { "BufRead", "BufReadPost" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local nmap = function(mode, keys, func, additional_args)
			additional_args = additional_args or {}
			vim.keymap.set(mode, keys, func, additional_args)
		end
		local octo = require("octo")
		octo.setup({
			picker = "telescope",
			picker_config = {
				checkout_pr = { lhs = "<C-o>", desc = "Checkout pull request" },
				merge_pr = { lhs = "<C-r>", desc = "Merge pull request" },
			},
		})
		-- PR
		nmap("n", "<leader>pa", "<cmd>Octo pr create<cr>", { desc = "Create PR" })
		nmap("n", "<leader>pl", "<cmd>Octo pr list<cr>", { desc = "PRs list" })
		nmap("n", "<leader>po", "<cmd>Octo pr checkout<cr>", { desc = "Checkout PR" })
		nmap("n", "<leader>pd", "<cmd>Octo pr diff<cr>", { desc = "Show PR diff" })
		nmap("n", "<leader>pc", "<cmd>Octo pr commits<cr>", { desc = "List PR commits" })
		nmap("n", "<leader>pf", "<cmd>Octo pr changes<cr>", { desc = "List PR files" })
		nmap("n", "<leader>pm", "<cmd>Octo pr merge<cr>", { desc = "Merge PR" })
		-- Issues
		nmap("n", "<leader>il", "<cmd>Octo issue list<cr>", { desc = "List issues" })
		nmap("n", "<leader>io", "<cmd>Octo issue create<cr>", { desc = "Create issue" })
		nmap("n", "<leader>ic", "<cmd>Octo issue close<cr>", { desc = "Close issue" })
		nmap("n", "<leader>ib", "<cmd>Octo issue browser<cr>", { desc = "Open issue in browser" })
		nmap("n", "<leader>ca", "<cmd>Octo comment add<cr>", { desc = "Add comment" })
	end,
	cond = in_git(),
}
