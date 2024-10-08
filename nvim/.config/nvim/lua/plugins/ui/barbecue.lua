return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons", -- optional dependency
  },
  config = function()
    local barbecue = require("barbecue")
    local navic = require("nvim-navic")
    navic.setup({
      highlight = true,
    })
    barbecue.setup({
      -- add options here
      theme = "catppuccin",
      attach_navic = false,
      create_autocmd = false,
    })

    vim.api.nvim_create_autocmd({
      "WinResized", -- or WinResized on NVIM-v0.9 and higher
      "BufWinEnter",
      "CursorHold",
      "InsertLeave",

      -- include this if you have set `show_modified` to `true`
      "BufModifiedSet",
    }, {
      group = vim.api.nvim_create_augroup("barbecue.updater", {}),
      callback = function()
        require("barbecue.ui").update()
      end,
    })
  end,
  -- lazy loading to prevent slowdown
  -- load when buffer has been loaded for reading
  event = { "BufRead", "BufReadPre", "BufNewFile" },
}
