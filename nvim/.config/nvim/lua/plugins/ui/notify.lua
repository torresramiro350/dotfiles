return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  enabled = false,
  -- event = "UIEnter",
  keys = {
    {
      "<leader>un",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Dismiss All Notifications",
    },
  },
  config = function()
    vim.notify = require("notify")
    local notify = require("notify")
    notify.setup({
      timeout = 2000,
      -- render = "compact",
      render = "wrapped-compact",
      stages = "fade",
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    })
  end,
}
