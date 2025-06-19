require("groups.utility_funcs")
return {

	"mrcjkb/rustaceanvim",
	priority = 1000,
	version = "^6", -- Recommended
	lazy = false, -- This plugin is already lazy
	ft = { "rust" },
	opts = {
		-- LSP configuration
		server = {
			on_attach = function(_, bufnr)
          -- stylua: ignore start
					vim.keymap.set("n", "<leader>cR", function() vim.cmd.RustLsp("codeAction") end, { desc = "Code Action", buffer = bufnr })
					vim.keymap.set("n", "<leader>dr", function() vim.cmd.RustLsp("debuggables") end, { desc = "Rust Debuggables", buffer = bufnr })
				-- stylua: ignore end
			end,
			default_settings = {
				-- rust-analyzer language server configuration
				["rust-analyzer"] = {
					cargo = {
						allFeatures = true,
						loadOutDirsFromCheck = true,
						buildScripts = {
							enable = true,
						},
					},
				},
				-- Add clippy lints for Rust
				checkOnSave = true,
				procMacro = {
					enable = true,
					ignored = {
						["async-trait"] = { "async_trait" },
						["napi-derive"] = { "napi" },
						["async-recursion"] = { "async_recursion" },
					},
				},
				files = {
					excludeDirs = {
						".direnv",
						".git",
						".github",
						".gitlab",
						"bin",
						"node_modules",
						"target",
						"venv",
						".venv",
					},
				},
			},
		},

		-- Plugin configuration
		tools = {},
		-- DAP configuration
		dap = {},
		float_win_config = {
			auto_focus = true,
			open_split = "vertical",
		},
	},
	config = function(_, opts)
		vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
		-- local package_path = require("mason-registry").get_package("codelldb").get
		-- local codelldb = package_path .. "/extension/adapter/codelldb"
		-- local library_path = package_path .. "/extension/lldb/lib/liblldb.dylib"
		-- local uname = io.popen("uname"):read("*l")
		-- if uname == "Linux" then
		-- 	library_path = package_path .. "/extension/lldb/lib/liblldb.so"
		-- end
		-- opts.dap = {
		-- 	adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
		-- }
	end,
}
