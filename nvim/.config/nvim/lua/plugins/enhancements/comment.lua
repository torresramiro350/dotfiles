-- "gc" to comment visual regions/lines
return {
  enabled = false,
  "numToStr/Comment.nvim",
  opts = {},
  event = { "BufReadPre", "BufReadPost", "BufNewFile" },
}
