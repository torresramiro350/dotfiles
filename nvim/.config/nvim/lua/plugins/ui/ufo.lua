require("groups.utility_funcs")
return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	event = { "BufRead", "BufNewFile" },
	enabled = true,
	config = function()
		-- add fancy fold text
		local handler = function(virtual_text, line_number, end_line_number, width, truncate)
			local new_viruatl_text = {}
			local suffix = (" 󰁂 %d "):format(end_line_number - line_number)
			local suf_width = vim.fn.strdisplaywidth(suffix)
			local target_width = width - suf_width
			local current_width = 0

			for _, chunk in ipairs(virtual_text) do
				local chunk_text = chunk[1]
				local chunk_width = vim.fn.strdisplaywidth(chunk_text)
				if target_width > current_width + chunk_width then
					table.insert(new_viruatl_text, chunk)
				else
					chunk_text = truncate(chunk_text, target_width - current_width)
					local highlight_group = chunk[2]
					table.insert(new_viruatl_text, { chunk_text, highlight_group })
					chunk_width = vim.fn.strdisplaywidth(chunk_text)
					if current_width + chunk_width < target_width then
						suffix = suffix .. (" "):rep(target_width - current_width - chunk_width)
					end
					break
				end
				current_width = current_width + chunk_width
			end
			table.insert(new_viruatl_text, { suffix, "MoreMsg" })
			return new_viruatl_text
		end
		local ufo = require("ufo")

		local peek_under_cursor = function()
			local winid = ufo.peekFoldedLinesUnderCursor()
			if not winid then
				vim.lsp.buf.hover()
			end
		end

		ufo.setup({
			fold_virt_text_handler = handler,
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
		})
		nmap("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
		nmap("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
		nmap("n", "zr", ufo.openFoldsExceptKinds, { desc = "Open all folds except kinds" })
		nmap("n", "zm", ufo.closeFoldsWith, { desc = "Close all folds with kinds" })
		nmap("n", "K", peek_under_cursor, { desc = "Peek folded lines under cursor" })
	end,
}
