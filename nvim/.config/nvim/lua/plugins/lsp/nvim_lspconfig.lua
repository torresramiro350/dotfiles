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
				"clangd",
				"clang-format",
				"shfmt",
				"markdownlint-cli2",
				"markdown-toc",
				"markdown-oxide",
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
		enabled = false,
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
			capabilities = {
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			},
			diagnostics = {
				update_in_insert = false,
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					prefix = "●",
					current_line = true,
					source = "if_many",
					spacing = 4,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			},
			inlay_hints = { enabled = true },
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
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
				yamlls = {
					filetypes = { "yaml", "yml" },
					capabilities = {
						textDocument = {
							foldingRange = {
								dynamicRegistration = false,
								lineFoldingOnly = true,
							},
						},
					},
					on_new_config = function(new_config)
						new_config.settings.yaml.schemas = vim.tbl_deep_extend(
							"force",
							new_config.settings.yaml.schemas or {},
							require("schemastore").yaml.schemas()
						)
					end,
					settings = {
						redhat = { telemetry = { enabled = false } },
						yaml = {
							keyOrdering = false,
							format = { enable = true },
							validate = true,
							schemaStore = {
								enable = false,
								url = "",
							},
						},
					},
				},
				-- Julia (not really using it)
				julials = {
					filetypes = { "julia" },
				},
				-- TOML files
				taplo = {
					filetypes = { "toml" },
				},
				tinymist = {},
			},
			-- setup = {
			-- 	["*"] = function(server, opts) end,
			-- },
		},
		config = function(_, opts)
			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local bufnr = event.buf
					local client_id = event.data.client_id
					local client = vim.lsp.get_client_by_id(client_id)
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

					nmap("<leader>rn", vim.lsp.buf.rename, "Rename buffer")
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
					nmap("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
					nmap("<leader>xl", vim.diagnostic.setloclist, "Open location list")
					nmap("<leader>xq", vim.diagnostic.setqflist, "Open quickfix list")
					nmap("<leader>Q", "<cmd>cclose<cr>", "Close quickfix list")
					nmap("<leader>L", "<cmd>lclose<cr>", "Close location list")
					nmap("gD", vim.lsp.buf.declaration, "Go to declaration")
				end,
			})

			local servers = opts.servers
			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local ensure_installed = vim.tbl_keys(servers or {})

			-- vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
			-- get all the servers that are available through mason-lspconfig
			if have_mason then
				mlsp.setup({
					ensure_installed = vim.tbl_deep_extend("force", ensure_installed, {}),
					automatic_enable = true,
					automatic_installation = true,
					handlers = {
						function(server_name)
							vim.lsp.config(server_name, servers[server_name])
						end,
					},
				})
			end
		end,
	},
}
