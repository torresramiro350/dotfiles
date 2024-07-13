require("groups.utility_funcs")
return {
  "folke/noice.nvim",
  -- event = "CmdlineEnter",
  -- event = "UIEnter",
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
          lsp_doc_border = true,
          bottom_search = true,
          long_message_split = true,
        },
      },
    })
    nmap("c", "<S-Enter>", function()
      noice.redirective(vim.fn.getcmdline())
    end, { desc = "Redirect cmdline" })

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

  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  },
}
