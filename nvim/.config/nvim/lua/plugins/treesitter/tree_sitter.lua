return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		version = false,
		enabled = true,
		lazy = false,
		build = ":TSUpdate",
		event = { "VeryLazy" },
		cmd = { "TSUpdateSync", "TSUpdate", "TSLog", "TSInstall" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		opts_extended = { "ensure_installed" },
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			folds = { enable = true },
			auto_install = true,
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"cmake",
				"dockerfile",
				"go",
				"json",
				"lua",
				"luadoc",
				"luap",
				"make",
				"markdown",
				"markdown_inline",
				"ninja",
				"rst",
				"python",
				"printf",
				"rust",
				"ssh_config",
				"regex",
				"toml",
				"vim",
				"vimdoc",
				"yaml",
			},
		},
		config = function(_, opts)
			local TS = require("nvim-treesitter")
			TS.setup(opts)
			TS.install(opts.ensure_installed)
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
				callback = function()
					if vim.tbl_get(opts, "highlight", "enable") then
						pcall(vim.treesitter.start)
					end
					if vim.tbl_get(opts, "indent", "enable") then
						vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					end
					if vim.tbl_get(opts, "folds", "enable") then
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		opts = function()
			local tsc = require("treesitter-context")
			Snacks.toggle({
				name = "Treesitter context",
				get = tsc.enabled,
				set = function(state)
					if state then
						tsc.enable()
					else
						tsc.disable()
					end
				end,
			}):map("<leader>ut")
			return { mode = "cursor", max_lines = 3, multiline_threshold = 3 }
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = "VeryLazy",
		opts = {
			move = {
				enable = true,
				set_jumps = true,
				keys = {
      -- stylua: ignore start
				goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
				goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
				goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
				goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
				},
				-- stylua: ignore end
			},
		},
		config = function(_, opts)
			local TS = require("nvim-treesitter-textobjects")
			if not TS.setup then
				vim.notify(
					"nvim-treesitter-textobjects: please update via your plugin manager (`main` branch required)",
					vim.log.levels.ERROR
				)
				return
			end
			TS.setup(opts)

			local function has_textobjects(ft)
				local lang = vim.treesitter.language.get_lang(ft) or ft
				local ok, query = pcall(vim.treesitter.query.get, lang, "textobjects")
				return ok and query ~= nil
			end

			local function attach(buf)
				local ft = vim.bo[buf].filetype
				if not (vim.tbl_get(opts, "move", "enable") and has_textobjects(ft)) then
					return
				end

				local moves = vim.tbl_get(opts, "move", "keys") or {}

				for method, keymaps in pairs(moves) do
					for key, query in pairs(keymaps) do
						local queries = type(query) == "table" and query or { query }
						local parts = {}
						for _, q in ipairs(queries) do
							local part = q:gsub("@", ""):gsub("%..*", "")
							part = part:sub(1, 1):upper() .. part:sub(2)
							table.insert(parts, part)
						end
						local desc = table.concat(parts, " or ")
						desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
						desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")

						vim.keymap.set({ "n", "x", "o" }, key, function()
							if vim.wo.diff and key:find("[cC]") then
								return vim.cmd("normal! " .. key)
							end
							require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
						end, {
							buffer = buf,
							desc = desc,
							silent = true,
						})
					end
				end
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter_textobjects_moves", { clear = true }),
				callback = function(ev)
					attach(ev.buf)
				end,
			})
			vim.tbl_map(attach, vim.api.nvim_list_bufs())
		end,
	},
}
