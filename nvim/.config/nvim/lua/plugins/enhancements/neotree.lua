require("groups.utility_funcs")

return {
  "nvim-neo-tree/neo-tree.nvim",
  event = { "BufNewFile", "BufReadPre", "BufReadPre" },
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local neotree = require("neo-tree")
    neotree.setup({
      source_selector = {
        winbar = true,
        statusline = false,
        show_scrolled_off_parent_node = false,
        pop_up_border_style = "rounded",
        sources = {
          {
            source = "filesystem", -- string
            display_name = " 󰉓 Files ", -- string | nil
          },
          {
            source = "buffers", -- string
            display_name = " 󰈚 Buffers ", -- string | nil
          },
          {
            source = "git_status", -- string
            display_name = " 󰊢 Git ", -- string | nil
          },
        },
      },
    })
    nmap("n", "<leader>E", "<cmd>Neotree toggle<cr>", { desc = "File list" })
  end,
}
