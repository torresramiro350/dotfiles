local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
-- autocmd("lspattach", {
-- 	group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
-- 	callback = function(args)
-- 		local client = vim.lsp.get_client_by_id(args.data.client_id)
-- 		if client == nil then
-- 			return
-- 		end
-- 		if client.name == "ruff" then
-- 			-- Disable hover in favor of pyright/basedpyright
-- 			client.server_capabilities.hoverProvider = false
-- 		end
-- 	end,
-- 	desc = "LSP: Disable hover capability from Ruff",
-- })

-- LSP
local completion = vim.g.completion_mode or "blink" -- or 'native'
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client == nil then
			return
		end
		if client.name == "ruff" then
			-- Disable hover in favor of pyright/basedpyright
			client.server_capabilities.hoverProvider = false
		end
		if client then
			-- Built-in completion
			if completion == "native" and client:supports_method("textDocument/completion") then
				vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
			end

			-- Inlay hints
			if client:supports_method("textDocument/inlayHints") then
				vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
			end
		end
	end,
})
