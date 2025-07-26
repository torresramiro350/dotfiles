-- NOTE: load in the general options to use with vim
require("vim_options.essential")

-- Load lazyvim's configuration
require("config.lazy")

-- vim.cmd.colorscheme("catppuccin-mocha")
vim.cmd.colorscheme("catppuccin")

-- load all the keymaps to a separate file
require("keymaps.mappings")
-- require("groups.init")
-- require("core.autocmds")
require("config.autocmds")

-- load the diagnostics configuration
require("utils.diagnostics")

vim.lsp.enable({
	"lua_ls",
	"basedpyright",
	"ruff",
	"bashls",
	"clangd",
	"yamlls",
	"jsonls",
	"neocmake",
	"markdown_oxide",
	"dockerls",
	"tinymist",
	"taplo",
})
