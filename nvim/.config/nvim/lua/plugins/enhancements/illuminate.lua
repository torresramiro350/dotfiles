return {
  "RRethy/vim-illuminate",
  event = { "BufReadPre", "BufNewFile" },
  enabled = false,
  config = function()
    -- illuminates all the instances of the current word under the cursor
    local illuminate = require("illuminate")
    illuminate.configure({
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    })
  end,
}
