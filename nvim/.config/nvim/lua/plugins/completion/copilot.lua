return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_filetypes = {
        latex = false,
        tex = false,
        python = true,
      }
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = { "BufReadPre" },
    branch = "canary",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        model = "gpt-4",
        auto_insert_mode = true,
        show_help = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          width = 0.4,
        },
        selection = function(source)
          local select = require("CopilotChat.select")
          return select.visual(source) or select.buffer(source)
        end,
      }
    end,
    keys = {
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end,
      },
      -- Show help actions with telescope
      -- { "<leader>ad", M.pick("help"),   desc = "Diagnostic Help (CopilotChat)", mode = { "n", "v" } },
      -- Show prompts actions with telescope
      -- { "<leader>ap", M.pick("prompt"), desc = "Prompt Actions (CopilotChat)",  mode = { "n", "v" } },
    },
    dependencies = {
      { "github/copilot.vim" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper,
    },
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        ft = "copilot-chat",
        title = "Copilot Chat",
        size = { width = 50 },
      })
    end,
  },
}
