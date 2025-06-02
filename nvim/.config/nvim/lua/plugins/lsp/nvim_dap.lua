return {
	"mfussenegger/nvim-dap",
	event = { "BufReadPre", "BufReadPost" },
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		{
			"rcarriga/nvim-dap-ui",
			keys = {
        -- stylua: ignore start
    { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
    { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
				-- stylua: ignore end
			},
			opts = {},
			config = function(_, opts)
				local dap = require("dap")
				local dapui = require("dapui")
				dapui.setup(opts)
				dap.listeners.after.event_initialized["dapui_config"] = function()
					dapui.open({})
				end
				dap.listeners.before.event_terminated["dapui_config"] = function()
					dapui.close({})
				end
				dap.listeners.before.event_exited["dapui_config"] = function()
					dapui.close({})
				end
			end,
		},
		-- virtual text for the debugger
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {},
		},
		{
			"mfussenegger/nvim-dap-python",
			ft = "python",
			event = { "BufReadPre", "BufReadPost" },
			config = function()
				local dap_python = require("dap-python")
				dap_python.setup("/home/rtorres/miniforge3/envs/swgo_fast/bin/python")
			end,
			keys = {
      -- stylua: ignore start
      { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
      { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
				-- stylua: ignore end
			},
		},
	},
	config = function()
		vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

		local dap, dapui = require("dap"), require("dapui")
		dap.adapters.gdb = {
			type = "executable",
			command = "gdb",
			args = { "-i", "dap" },
		}

		-- C
		dap.configurations.c = {
			{
				name = "Launch",
				type = "gdb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopAtBeginningOfMainSubprogram = false,
			},
		}

		-- C++
		dap.configurations.cpp = {
			{
				name = "Launch",
				type = "gdb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopAtBeginningOfMainSubprogram = false,
			},
		}

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
    -- stylua: ignore
    vim.keymap.set("n", "<Leader>dt", function() dap.toggle_breakpoint() end, { desc = "Toggle break point" })
    -- stylua: ignore
    vim.keymap.set("n", "<leader>dc", function() dap.continue() end, { desc = "Continue debugging" })
	end,
	-- event = "VeryLazy",
	keys = {
    -- stylua: ignore start
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
		-- stylua: ignore end
	},
}
