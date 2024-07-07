return {
  "rcarriga/nvim-notify",
  -- event = "VeryLazy",
  -- event = "UIEnter",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.notify = require("notify")
    local notify = require("notify")
    notify.setup({
      timeout = 2000,
      -- render = "compact",
      render = "wrapped-compact",
      stages = "fade",
    })
  end,
}
