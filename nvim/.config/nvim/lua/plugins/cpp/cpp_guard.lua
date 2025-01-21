return {
  "pogyomo/cppguard.nvim",
  dependencies = {
    -- "L3MON4D3/LuaSnip", -- If you're using luasnip.
    "echasnovski/mini.snippets",
  },
  event = { "BufNewFile", "BufRead", "BufReadPre" },
  ft = { "c", "cxx", "h", "hxx", "cpp", "objc", "objcpp", "cuda", "proto" },
}
