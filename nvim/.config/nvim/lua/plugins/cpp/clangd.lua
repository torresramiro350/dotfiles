return {
  "p00f/clangd_extensions.nvim",
  event = { "BufNewFile", "BufReadPre", "BufReadPost" },
  ft = { "c", "cxx", "h", "hxx", "cpp", "objc", "objcpp", "cuda", "proto" },
  -- config = function()
  --   require("clangd_extensions.inlay_hints").setup_autocmd()
  --   require("clangd_extensions.inlay_hints").set_inlay_hints()
  -- end,
}
