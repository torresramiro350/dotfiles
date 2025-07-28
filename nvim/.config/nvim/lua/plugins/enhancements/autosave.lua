return {
	{
		"okuuva/auto-save.nvim",
		enabled = true,
		cmd = "ASToggle",
		event = { "InsertLeave", "TextChanged" },
		opts = function()
			local group = vim.api.nvim_create_augroup("autosave", {})
			local augroup = vim.api.nvim_create_augroup
			local autocmd = vim.api.nvim_create_autocmd
			local execaucmds = vim.api.nvim_exec_autocmds

			autocmd("User", {
				pattern = "AutoSaveWritePost",
				group = group,
				callback = function(opts)
					if opts.data.saved_buffer ~= nil then
						print("AutoSaved")
					end
				end,
			})

			-- prevent saving when in visual mode
			local visual_event_grup = augroup("visual_event_grup", { clear = true })

			autocmd("ModeChanged", {
				group = visual_event_grup,
				pattern = { "*:[vV\x16]*" },
				callback = function()
					execaucmds("User", { pattern = "VisualEnter" })
				end,
			})

			autocmd("ModeChanged", {
				group = group,
				pattern = { "[vV\x16]*:*" },
				callback = function()
					execaucmds("User", { pattern = "VisualLeave" })
				end,
			})

			-- need to figure out why flash is not loaded
			local flash = require("flash")
			local original_jump = flash.jump
			flash.jump = function(opts)
				execaucmds("User", { pattern = "FlashJumpStart" })
				original_jump(opts)
				execaucmds("User", { pattern = "FlashJumpEnd" })
			end

			-- Disable auto-save when entering a snacks_input buffer
			autocmd("FileType", {
				pattern = "snacks_input",
				group = group,
				callback = function()
					execaucmds("User", { pattern = "SnacksInputEnter" })
				end,
			})

			autocmd("BufLeave", {
				group = group,
				pattern = "*",
				callback = function(opts)
					local ft = vim.bo[opts.buf].filetype
					if ft == "snacks_input" then
						execaucmds("User", { pattern = "SnacksInputLeave" })
					end
				end,
			})

			autocmd("FileType", {
				pattern = "snacks_picker_input",
				group = group,
				callback = function()
					execaucmds("User", { pattern = "SnacksPickerInputEnter" })
				end,
			})

			autocmd("BufLeave", {
				group = group,
				pattern = "*",
				callback = function(opts)
					local ft = vim.bo[opts.buf].filetype
					if ft == "snacks_picker_input" then
						execaucmds("User", { pattern = "SnacksPickerInputLeave" })
					end
				end,
			})

			-- return the configured plugin
			return {
				enabled = true,
				trigger_events = {
					immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" },
					defer_save = {
						"InsertLeave",
						"TextChanged",
						{ "User", pattern = "VisualLeave" },
						{ "User", pattern = "FlashJumpEnd" },
						{ "User", pattern = "SnacksInputLeave" },
						{ "User", pattern = "SnacksPickerInputLeave" },
					},
					cancel_deferred_save = {
						"InsertEnter",
						{ "User", pattern = "VisualEnter" },
						{ "User", pattern = "FlashJumpStart" },
						{ "User", pattern = "SnacksInputEnter" },
						{ "User", pattern = "SnacksPickerInputEnter" },
					},
				},
				condition = function(buf)
					local mode = vim.fn.mode
					if mode == "i" then
						return false
					end
					local filetype = vim.bo[buf].filetype

					if filetype == "harpoon" then
						return false
					end
					return true
				end,
				-- write all bufferns when the current one meets `condition`
				write_all_buffers = false,
				-- do not execute autocmds when saving
				-- if this is enabled, then the autosave won't trigger autoformat
				noautocmd = false,
				lockmarks = false, -- lock marks when saving, see `:h lockmarks` for more details
				debug = false,
				debounce_delay = 3000, -- delay saving until after 2 seconds
			}
		end,
		config = function(_, opts)
			require("auto-save").setup(opts)
		end,
	},
}
