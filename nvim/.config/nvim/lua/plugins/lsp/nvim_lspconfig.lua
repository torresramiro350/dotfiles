return {
	{
		"williamboman/mason-lspconfig.nvim",
		config = function() end,
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		event = "VeryLazy",
		opts_extended = {
			"ensure_installed",
		},
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
			},
		},
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)
			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		event = { "BufNewFile", "BufReadPre", "BufReadPost" },
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ "williamboman/mason.nvim", opts = {} },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "saghen/blink.cmp" },
			-- { "hrsh7th/cmp-nvim-lsp" },
			-- { "j-hui/fidget.nvim" },
		},
		opts = {
			inlay_hints = { enabled = true },
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJit" },
							workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
							telemetry = { enable = false },
							codeLens = { enable = true },
							completion = {
								callSnippet = "Replace",
							},
							doc = {
								privateName = { "^_" },
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
						},
					},
					filetypes = { "lua" },
					cmd = { "lua-language-server" },
					single_file_support = true,
				},
				basedpyright = {
					settings = {
						basedpyright = {
							analysis = {
								autoSearchPaths = true,
								diagnosticMode = "openFilesOnly",
								useLibraryCodeForTypes = true,
							},
						},
					},
				},
				ruff = {
					cmd_env = { RUFF_TRACE = "messages" },
					init_options = {
						settings = {
							logLevel = "error",
						},
					},
				},
				-- C++
				clangd = {
					root_dir = function(fname)
						return require("lspconfig.util").root_pattern(
							"Makefile",
							"compile_commands.json",
							"compile_flags.txt"
						)(fname)
					end,
					capabilities = {
						offsetEncoding = { "utf-16" },
					},
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--function-arg-placeholders",
						"--fallback-style=llvm",
					},
					init_options = {
						usePlaceholders = true,
						completeunimported = true,
						clangdFileStatus = true,
					},
				},
				-- Bash
				bashls = {
					filetypes = { "sh" },
				},
				-- CMake
				neocmake = {},
				-- Markdown
				markdown_oxide = {},
				-- Json
				jsonls = { filetypes = { "json" } },
				-- Yaml
				yamlls = { filetypes = { "yaml", "yml" } },
				-- Julia (not really using it)
				julials = {
					filetypes = { "julia" },
				},
				-- TOML files
				taplo = {
					filetypes = { "toml" },
				},
				-- RST
				ltex = {
					filetypes = { "rst", "tex", "bib" },
				},
				tinymist = {},
			},
		},
		config = function(_, opts)
			-- local function setup_codelens(client, bufnr)
			-- 	if client.supports_method("textDocuments/codeLens") then
			-- 		vim.lsp.codelens.refresh()
			-- 		local group = vim.api.nvim_create_augroup("LSPCodeLens", { clear = true })
			-- 		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			-- 			buffer = bufnr,
			-- 			group = group,
			-- 			callback = function()
			-- 				vim.lsp.codelens.refresh()
			-- 			end,
			-- 		})
			-- 	end
			-- end

			-- Whenever an LSP attaches to a buffer, we will run this function.
			-- See `:help LspAttach` for more information about this autocmd event.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach-format", { clear = true }),
				-- This is where we attach the autoformatting for reasonable clients
				callback = function(event)
					local bufnr = event.buf
					local client_id = event.data.client_id
					local client = vim.lsp.get_client_by_id(client_id)

					-- setup_codelens(client, bufnr)
					if client == nil then
						return
					end
					if client.name == "ruff" then
						-- Disable hover in favor of Pyright
						client.server_capabilities.hoverProvider = false
					end

					-- load the clangd extensions plugin for CXX code
					if client.name == "clangd" then
						require("clangd_extensions")
					end

					local nmap = function(keys, func, desc)
						if desc then
							desc = "LSP: " .. desc
						end

						vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
					end

					local function diagnostic_goto(direction, severity)
						local go = vim.diagnostic["goto_" .. (direction and "next" or "prev")]
						if type(severity) == "string" then
							severity = vim.diagnostic.severity[severity]
						end
						return function()
							go({ severity = severity })
						end
					end

					nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					nmap("<leader>ca", vim.lsp.buf.code_action, "Code Actions")
					nmap("K", vim.lsp.buf.hover, "Hover Documentation")
					nmap("gk", vim.lsp.buf.signature_help, "Signature Documentation")
					nmap("[d", diagnostic_goto(false), "Go to previous diagnostic message")
					nmap("]d", diagnostic_goto(true), "Go to next diagnostic message")
					nmap("[e", diagnostic_goto(false, "ERROR"), "Go to previous error")
					nmap("]e", diagnostic_goto(true, "ERROR"), "Go to next error")
					nmap("[w", diagnostic_goto(false, "WARN"), "Go to previous warning")
					nmap("]w", diagnostic_goto(true, "WARN"), "Go to next warning")
					-- nmap("[q", vim.cmd.cprev, "Go to previous quickfix item")
					-- nmap("]q", vim.cmd.cnext, "Go to next quickfix item")
					nmap("]Q", vim.cmd.clast, "End of quickfix list")
					nmap("[Q", vim.cmd.cfirst, "Beginning of quickfix list")
					nmap("[l", vim.cmd.lnext, "Next loclist")
					nmap("]l", vim.cmd.lprev, "Previous loclist")
					nmap("]L", vim.cmd.llast, "End of loclist")
					nmap("[L", vim.cmd.lfirst, "Beginning of loclist")
					nmap("<leader>e", vim.diagnostic.open_float, "Open [F]loating [D]iagnostic message")
					nmap("<leader>xl", vim.diagnostic.setloclist, "Open [D]iagnostics [L]ist")
					nmap("<leader>xq", vim.diagnostic.setqflist, "Open [Q]uickfix [L]ist")
					nmap("<leader>Q", "<cmd>cclose<cr>", "Close quickfix list")
					nmap("<leader>L", "<cmd>lclose<cr>", "Close location list")
					nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					nmap("<leader>Wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
					nmap("<leader>Wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
					nmap("<leader>Wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, "[W]orkspace [L]ist Folders")
					nmap("<leader>lf", "<cmd>Format<cr>", "[L]format")

					-- allow inlay hints for clangd
					-- nmap("<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", "Switch Source/Header (C/C++)")
					local group = vim.api.nvim_create_augroup("clangd_no_inlay_hints_insert", { clear = true })
					nmap("<leader>lh", function()
						-- if require("clangd.extensions.inlay_hints")
						if require("clangd_extensions.inlay_hints").toggle_inlay_hints() then
							vim.api.nvim_create_autocmd("InsertEnter", {
								group = group,
								buffer = bufnr,
								callback = require("clangd_extensions.inlay_hints").disable_inlay_hints,
							})
							vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
								group = group,
								buffer = bufnr,
								callback = require("clangd_extensions.inlay_hints").set_inlay_hints,
							})
						else
							vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
						end
					end, "[l]sp [h]ints toggle")
					-- nmap("<leader>Ws", builtins.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				end,
			})
			-- Change the Diagnostic symbols in the sign column (gutter)
			if vim.g.have_nerd_font then
				local signs = { ERROR = " ", WARN = " ", HINT = "󰠠 ", INFO = " " }
				local diagnostic_signs = {}
				for type, icon in pairs(signs) do
					diagnostic_signs[vim.diagnostic.severity[type]] = icon
				end
				vim.diagnostic.config({
					underline = true,
					update_in_insert = false,
					severity_sort = true,
					-- virtual_lines = { current_line = true },
					virtual_text = {
						current_line = true,
						spacing = 4,
						source = "if_many",
						prefix = "●",
					},
					signs = { text = diagnostic_signs },
				})
			end

			local servers = opts.servers
			local lspconfig = require("lspconfig")
			-- local capabilities = require("blink.cmp").get_lsp_capabilities()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
			local ensure_installed = vim.tbl_keys(servers or {})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						-- don't forget to call this, otherwise the servers won't be loaded
						lspconfig[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
