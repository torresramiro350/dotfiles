-- check whether we are within a git repo
--
function in_git()
	if vim.api.nvim_command_output("!git rev-parse --is-inside-work-tree") == "true" then
		return true
	end
end

-- small utility function to make defining keymaps easier
function nmap(mode, keys, func, additional_args)
	additional_args = additional_args or {}
	vim.keymap.set(mode, keys, func, additional_args)
end

-- small utility function to make defining keymaps easier
function nmap_api(mode, keys, func, additional_args)
	additional_args = additional_args or {}
	vim.api.nvim_set_keymap(mode, keys, func, additional_args)
end
