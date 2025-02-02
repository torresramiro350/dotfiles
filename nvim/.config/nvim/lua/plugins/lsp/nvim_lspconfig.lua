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
			"williamboman/mason.nvim",
			{
				"williamboman/mason-lspconfig.nvim",
				config = function() end,
			},
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "saghen/blink.cmp" },
			-- { "hrsh7th/cmp-nvim-lsp" },
			-- { "j-hui/fidget.nvim" },
		},
		opts = {
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
					single_file_support = true,
					filetypes = "python",
					cmd = { "basedpyright-langserver", "--stdio" },
					settings = {
						basedpyright = {
							analysis = {
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "openFilesOnly",
								inlayHints = {
									callArgumentNames = true,
								},
							},
						},
					},
				},
				pyright = {
					single_file_support = true,
					filetypes = "python",
					cmd = { "pyright-langserver", "--stdio" },
					settings = {
						pyright = { disableOrganizeImports = true },
						python = {
							analysis = {
								-- Ignore all files for analysis to exclusively
								-- use Ruff for linting
								ignore = { "*" },
								-- autoSearchPaths = true,
								-- diagnosticMode = "openFilesOnly",
								-- useLibraryCodeForTypes = true,
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
				clangd = {
					filetypes = { "c", "cxx", "h", "hxx", "objc", "objcpp", "cuda", "proto" },
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
				bashls = {
					filetypes = { "sh" },
				},
				neocmake = {},
				markdown_oxide = {},
				jsonls = { filetypes = { "json" } },
				yamlls = { filetypes = { "yaml", "yml" } },
				julials = {
					filetypes = { "julia" },
				},
				taplo = {
					filetypes = { "toml" },
				},
			},
		},
		config = function()
			--import lspconfig plugin
			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			--

			-- Whenever an LSP attaches to a buffer, we will run this function.
			-- See `:help LspAttach` for more information about this autocmd event.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach-format", { clear = true }),
				-- This is where we attach the autoformatting for reasonable clients
				callback = function(event)
					local client_id = event.data.client_id
					local client = vim.lsp.get_client_by_id(client_id)
					local bufnr = event.buf
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
					nmap("<leader>k", vim.lsp.buf.signature_help, "Signature Documentation")
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

					-- nmap("gd", builtins.lsp_definitions, "[G]oto [D]efinition")
					-- nmap("gr", builtins.lsp_references, "[G]oto [R]eferences")
					-- nmap("gI", builtins.lsp_implementations, "[G]oto [I]mplementation")
					-- nmap("gy", builtins.lsp_type_definitions, "Type [D]efinition")
					-- nmap("<leader>ds", builtins.lsp_document_symbols, "[D]ocument [S]ymbols")
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
					virtual_text = {
						spacing = 4,
						source = "if_many",
						prefix = "●",
					},
					signs = { text = diagnostic_signs },
				})
			end

			local lspconfig = require("lspconfig")
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			-- local cmp_nvim_lsp = require("cmp_nvim_lsp")
			-- local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
			--
			-- julia
			lspconfig.julials.setup({
				capabilities = capabilities,
			})

			-- configure python server
			-- since it's in alpha stage, we need to use the ruff-lsp server
			lspconfig.ruff.setup({
				capabilities = capabilities,
				on_attach = function(client, _)
					client.server_capabilities.hoverProvider = false
				end,
			})

			-- pyright
			lspconfig.basedpyright.setup({
				capabilities = capabilities,
			})

			-- lspconfig.pyright.setup({
			-- 	capabilities = capabilities,
			-- 	on_attach = on_attach,
			-- })

			--bash
			lspconfig.bashls.setup({
				capabilities = capabilities,
			})

			-- cmake
			lspconfig.neocmake.setup({
				capabilities = capabilities,
			})

			-- markdown
			lspconfig.markdown_oxide.setup({
				capabilities = capabilities,
			})

			-- C/C++
			lspconfig.clangd.setup({
				capabilities = {
					capabilities,
					offsetEncoding = "utf-8",
				},
			})

			-- json
			lspconfig.jsonls.setup({
				capabilities = capabilities,
			})

			-- yaml
			lspconfig.yamlls.setup({
				capabilities = capabilities,
			})

			-- Lua
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			-- TOML
			lspconfig.taplo.setup({
				capabilities = capabilities,
			})
		end,
	},
}
