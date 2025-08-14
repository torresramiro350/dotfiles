return {
	"akinsho/bufferline.nvim",
	event = { "BufEnter", "BufReadPre" },
	opts = function()
		local highlights = require("catppuccin.groups.integrations.bufferline")
		return {
			highlights = highlights.get(),
			options = {
        -- stylua: ignore start
				close_command = function(n) Snacks.bufdelete(n) end,
				right_mouse_command = function(n) Snacks.bufdelete(n) end,
				-- stylua: ignore end
				always_show_bufferline = false,
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(_, _, diag)
					-- diagnostics_indicator = function(count, level, _)
					local icons = { Error = "󰅚 ", Warning = "󰀪 ", Info = "󰋽 ", Hint = "󰌶 " }
					local ret = (diag.error and icons.Error .. diag.error .. " " or "")
						.. (diag.warning and icons.Warning .. diag.warning .. " " or "")
					return vim.trim(ret)
				end,
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						highlight = "Directory",
						text_align = "left",
					},
					{
						filetype = "snacks_layout_box",
					},
				},
			},
		}
	end,
	config = function(_, opts)
		require("bufferline").setup(opts)
		vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
			callback = function()
				vim.schedule(function()
					pcall(nvim_bufferline)
				end)
			end,
		})
	end,
}
