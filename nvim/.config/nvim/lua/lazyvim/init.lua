-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
-- `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	checker = { enabled = true },
	-- { import = "plugins" }, -- enough if all plugins live in a single directory
	{ import = "plugins.enhancements" },
	{ import = "plugins.tmux" },
	{ import = "plugins.completion" },
	{ import = "plugins.cpp" },
	{ import = "plugins.documentation" },
	{ import = "plugins.notes" },
	{ import = "plugins.git" },
	{ import = "plugins.lsp" },
	{ import = "plugins.rust" },
	{ import = "plugins.sessions" },
	{ import = "plugins.treesitter" },
	{ import = "plugins.telescope" },
	{ import = "plugins.typing" },
	{ import = "plugins.ui" },
})
