return {
  "lukas-reineke/headlines.nvim",
  dependencies = "nvim-treesitter/nvim-treesitter",
  ft = { "markdown", "neorg" },
  event = { "BufRead", "BufNewFile" },
  config = function()
    local headlines = require("headlines")
    headlines.setup({})
  end,
}
