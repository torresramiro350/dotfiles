return {
  "MeanderingProgrammer/render-markdown.nvim",
  event = { "BufRead", "BufNewFile" },
  ft = "markdown",
  opts = {},
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
}
