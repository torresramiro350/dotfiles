require("groups.utility_funcs")
return {
  "folke/noice.nvim",
  event = "VimEnter",
  priority = 1000,
  config = function()
    local noice = require("noice")

    noice.setup({
      lsp = {
        override = {
          ["cmp.entry.get_documentation"] = true,
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
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
          bottom_search = true,    -- use a classic bottom cmdline for search
          command_palette = true,  -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,      -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true,   -- add a border to hover docs and signature help
          long_message_split = true,
        },
      },
    })

    -- stylua: ignore start
    nmap(
      "n", "<leader>nl", function() noice.cmd("last") end,
      { desc = "Show last message in popup" }
    )
    nmap(
      "n", "<leader>nh", function() noice.cmd("history") end,
      { desc = "Show history of messages in popup" }
    )
    nmap("c", "<S-Enter>", function() noice.redirective(vim.fn.getcmdline()) end,
      { desc = "Redirect cmdline" }
    )

    nmap({ "n", "i", "s" }, "<c-f>", function()
      if not require("noice.lsp").scroll(4) then
        return "<c-f>"
      end
    end, { silent = true, expr = true })

    nmap({ "n", "i", "s" }, "<c-b>", function()
      if not require("noice.lsp").scroll(-4) then
        return "<c-b>"
      end
    end, { silent = true, expr = true })
  end,
  -- stylua: ignore end

  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  },
}
