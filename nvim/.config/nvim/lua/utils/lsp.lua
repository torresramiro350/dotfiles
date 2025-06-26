local Path = require("utils.path")

local M = {}
function M.get_default_keymaps()
	return {
		{ keys = "<leader>rn", func = vim.lsp.buf.rename, desc = "Rename buffer" },
		{ keys = "<leader>ca", func = vim.lsp.buf.code_action, desc = "Code Actions" },
		{ keys = "<leader>cA", func = M.action.source, desc = "Source Actions" },
		{ keys = "<leader>cr", func = vim.lsp.buf.rename, desc = "Code Rename" },
		{ keys = "<leader>cf", func = vim.lsp.buf.format, desc = "Code Format" },
		{ keys = "<leader>k", func = vim.lsp.buf.hover, desc = "Documentation", has = "hoverProvider" },
		{ keys = "K", func = vim.lsp.buf.hover, desc = "Documentation", has = "hoverProvider" },
		{
			keys = "gk",
			func = vim.lsp.buf.signature_help,
			desc = "Signature Documentation",
			has = "definitionProvider",
		},
		{ keys = "<leader>cf", func = vim.lsp.buf.format, desc = "Code Format" },
	}
end

M.on_attach = function(client, buffer)
	local keymaps = M.get_default_keymaps()
	for _, keymap in ipairs(keymaps) do
		if not keymap.has or client.server_capabilities[keymap.has] then
			vim.keymap.set(keymap.mode or "n", keymap.keys, keymap.func, {
				buffer = buffer,
				desc = "LSP: " .. keymap.desc,
				nowait = keymap.nowait,
			})
		end
	end
end

M.action = setmetatable({}, {
	__index = function(_, action)
		return function()
			vim.lsp.buf.code_action({
				apply = true,
				context = {
					only = { action },
					diagnostics = {},
				},
			})
		end
	end,
})

-- Utils for conform
--- Get the path of the config file in the current directory or the root of the git repo
---@param filename string
---@return string | nil
local function get_config_path(filename)
	local current_dir = vim.fn.getcwd()
	local config_file = current_dir .. "/" .. filename
	if vim.fn.filereadable(config_file) == 1 then
		return current_dir
	end

	-- If the current directory is a git repo, check if the root of the repo
	-- contains a biome.json file
	local git_root = Path.get_git_root()
	if Path.is_git_repo() and git_root ~= current_dir then
		config_file = git_root .. "/" .. filename
		if vim.fn.filereadable(config_file) == 1 then
			return git_root
		end
	end

	return nil
end

return M
