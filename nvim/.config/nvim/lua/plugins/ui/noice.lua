return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    {
      "MunifTanjim/nui.nvim",
      config = function()
        local Popup = require("nui.popup")
        Popup({
          win_options = {
            winhighlight = {
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        })
      end,
    },
    "rcarriga/nvim-notify",
  },
  priority = 1000,
  opts = {
    lsp = {
      override = {
        ["cmp.entry.get_documentation"] = true,
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
    presets = {
      bottom_search = true,      -- use a classic bottom cmdline for search
      command_palette = false,   -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      -- inc_rename = false,        -- enables an input dialog for inc-rename.nvim
      -- lsp_doc_border = false,    -- add a border to hover docs and signature help
      -- long_message_split = false,
    },
  },
  -- stylua: ignore start
  keys = {
    { "<leader>snl", function() require("noice").cmd("last") end,    desc = "Show last message in popup", },
    { "<leader>snh", function() require("noice").cmd("history") end, desc = "Show history of messages in popup" },
    { "<leader>snt", function() require("noice").cmd("pick") end,    desc = "Noice picker (Telescope/fzf lua)" },
    { "<leader>sna", function() require("noice").cmd("all") end,     desc = "Noice all" },
    { "<leader>snd", function() require("noice").cmd("dismis") end,  desc = "Noice dismiss" },
    {
      "<S-Enter>",
      function() require("noice").redirective(vim.fn.getcmdline()) end,
      desc = "Redirect cmdline",
      mode = "c"
    },
    {
      "<c-f>",
      function()
        if not require("noice.lsp").scroll(4) then return "<c-f>" end
      end,
      desc = "Scroll forward",
      silent = true,
      expr = true,
      mode = { "n", "i", "s" }
    },
    { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, desc = "Scroll backward", silent = true, expr = true, mode = { "n", "i", "s" } },
  },
  -- stylua: ignore end
  config = function(_, opts)
    if vim.o.filetype == "lazy" then
      vim.cmd([[messages clear]])
    else
      require("noice").setup(opts)
    end
  end,
}
