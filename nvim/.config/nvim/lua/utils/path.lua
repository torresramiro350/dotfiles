local M = {}

--- Check whether the root directory is a git repo
--- @return boolean
function M.is_git_repo()
	vim.fn.system("git rev-parse --is-inside-work-tree")
	return vim.v.shell_error == 0
end

--- Get the root directory
---@return string | nil
function M.get_git_root()
	return vim.fn.systemlist("git rev-parse --show-toplevel")[1]
end

--- Get root directory of git project or fallback to current directory
---@return string | nil
function M.get_root_directory()
	if M.is_git_repo() then
		return M.get_git_root()
	end
	return vim.fn.getcwd()
end

return M
