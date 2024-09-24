return {
  "folke/flash.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    modes = {
      char = {
        jump_labels = true,
      },
      search = {
        enabled = true,
        highlight = { backdrop = true },
        jump = { history = true, register = true, nohlsearch = true },
      },
    },
    label = {
      uppercase = true,
      rainbow = {
        enabled = true,
        shade = 2,
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
  },
}
