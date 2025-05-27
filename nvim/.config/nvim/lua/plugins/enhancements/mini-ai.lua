return {
	"echasnovski/mini.ai",
	version = false,
	event = "BufReadPost",
	opts = function()
		local ai = require("mini.ai")
		return {
			n_lines = 500,
			search_method = "cover_or_next",
			custom_textobjects = {
				o = ai.gen_spec.treesitter({ -- code block
					a = { "@block.outer", "@conditional.outer", "@loop.outer" },
					i = { "@block.inner", "@conditional.inner", "@loop.inner" },
				}),
				f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
				c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
				t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
				e = { -- Word with case
					{ "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
					"^().*()$",
				},
				u = ai.gen_spec.function_call(), -- u for usage
				U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
			},
			mappings = {
				-- Main textobject prefixes
				around = "a",
				inside = "i",
				-- Next/last variants
				around_next = "an",
				inside_next = "in",
				around_last = "al",
				inside_last = "il",
				goto_left = "[g",
				goto_right = "]g",
			},
		}
	end,
	config = function(_, opts)
		local ai = require("mini.ai")
		ai.setup(opts)
	end,
}
