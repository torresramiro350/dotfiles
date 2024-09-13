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
      {
        "<leader>ad",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.help_actions())
        end,
        desc = "Diagnostic Help (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        desc = "Prompt Actions (CopilotChat)",
        mode = { "n", "v" },
      },
      -- Show help actions with telescope
      -- { "<leader>ad", M.pick("help"),   desc = "Diagnostic Help (CopilotChat)", mode = { "n", "v" } },
      -- Show prompts actions with telescope
      -- { "<leader>ap", M.pick("prompt"), desc = "Prompt Actions (CopilotChat)",  mode = { "n", "v" } },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      require("CopilotChat.integrations.cmp").setup()

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })
      chat.setup(opts)
    end,
    dependencies = {
      { "github/copilot.vim" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper,
    },
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    -- optional = true,
    keys = {
      {
        "<leader>ue",
        function()
          require("edgy").toggle()
        end,
        desc = "Edgy Toggle",
      },
      -- stylua: ignore
      { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
    },
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        ft = "copilot-chat",
        title = "Copilot Chat",
        size = { width = 40 },
      })
      opts.bottom = opts.bottom or {}
      table.insert(opts.bottom, {
        ft = "noice",
        size = { height = 0.4 },
        filter = function(buf, win)
          return vim.api.nvim_win_get_config(win).relative == ""
        end,
      })
    end,
  },
}
