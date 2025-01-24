return {
  "folke/todo-comments.nvim",
  -- version = "*",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = { "BufRead", "BufNewFile" },
  -- event = { "BufReadPost", "BufNewFile" },
  opts = {
    highlight = {
      comments_only = true,
    },
  },
  keys = {
    -- stylua: ignore start
    { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
    { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
    { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
    { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
    { "<leader>st", function() Snacks.picker.todo_comments() end,        desc = "Todo" },
    {
      "<leader>sT",
      function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end,
      desc = "Todo/Fix/Fixme"
    },
    -- { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
    -- { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
    -- stylua: ignore stop
  },
}
