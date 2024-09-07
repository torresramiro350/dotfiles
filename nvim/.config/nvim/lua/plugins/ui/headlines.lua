return {
  "lukas-reineke/headlines.nvim",
  enabled = false,
  dependencies = "nvim-treesitter/nvim-treesitter",
  ft = { "markdown", "neorg" },
  event = { "BufRead", "BufNewFile" },
  config = function()
    local headlines = require("headlines")
    headlines.setup({
      markdown = {
        fat_headlines = true,
      },
    })
  end,
}
