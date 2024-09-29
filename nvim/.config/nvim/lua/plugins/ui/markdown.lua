return {
  -- event = { "BufReadPre", "BufNewFile" },
  event = { "BufRead", "BufNewFile" },
  ft = "markdown",
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {},
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
}
