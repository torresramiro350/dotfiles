require("groups.utility_funcs")
return {
  "stevearc/aerial.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local aerial = require("aerial")
    aerial.setup({
      layout = {
        max_width = { 40, 0.2 },
        width = 20,
        min_width = 10,
        resize_to_content = false,
        win_opts = {
          winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
          signcolumn = "yes",
          statuscolumn = " ",
        },
        guides = {
          mid_item = "├╴",
          last_item = "└╴",
          nested_top = "│ ",
          whitespace = "  ",
        },
      },
    })
    nmap("n", "<leader>cs", "<cmd>AerialToggle<CR>", { desc = "Toggle Aerial" })
    on_attach = function(bufnr)
      -- Jump forwards/backwards with '{' and '}'
      nmap("n", "{", "<cmd>AerialPrev<CR>", { desc = "Aerial Prev", buffer = bufnr })
      nmap("n", "}", "<cmd>AerialNext<CR>", { desc = "Aerial Next", buffer = bufnr })
    end
  end,
}
