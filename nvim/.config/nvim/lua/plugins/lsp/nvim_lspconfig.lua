return {
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
			{ "williamboman/mason-lspconfig.nvim", config = function() end },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "saghen/blink.cmp" },
			-- { "hrsh7th/cmp-nvim-lsp" },
			-- { "j-hui/fidget.nvim" },
		},
		opts = {
			capabilities = function()
				local capabilities = vim.lsp.protocol.make_client_capabilities()
				local has_blink, blink = pcall(require, "blink.cmp")
				return vim.tbl_deep_extend("force", capabilities, has_blink and blink.get_lsp_capabilities() or {}, {
					textDocument = {
						foldingRange = {
							dynamicRegistration = false,
							lineFoldingOnly = true,
						},
					},
				})
			end,
			diagnostics = function()
				local signs = { ERROR = " ", WARN = " ", HINT = "󰠠 ", INFO = " " }
				local diagnostic_signs = {}
				for type, icon in pairs(signs) do
					diagnostic_signs[vim.diagnostic.severity[type]] = icon
				end
				return {
					underline = true,
					update_in_insert = false,
					severity_sort = true,
					virtual_text = {
						current_line = true,
						spacing = 4,
						source = "if_many",
						prefix = "●",
					},
					signs = { text = diagnostic_signs },
				}
			end,
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
							"configure.ac",
							"configure.in",
							"config.h.in",
							"meson.build",
							"meson_options.txt",
							"build.ninja"
						)(fname) or require("lspconfig.util").root_pattern(
							"compile_commands.json",
							"compile_flags.txt"
						)(fname) or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
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
						completeUnimported = true,
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
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
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
				end,
			})

			vim.diagnostic.config(opts.diagnostics())

			local servers = opts.servers
			local lspconfig = require("lspconfig")
			local capabilities = opts.capabilities()
			local ensure_installed = vim.tbl_keys(servers or {})
			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})
				if server_opts.enabled == false then
					return
				end

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				lspconfig[server].setup(server_opts)
			end
			-- get all the servers that are available through mason-lspconfig
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
				handlers = { setup },
			})
		end,
	},
}
