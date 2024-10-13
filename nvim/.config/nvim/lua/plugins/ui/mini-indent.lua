return {
  "echasnovski/mini.indentscope",
  version = false,
  -- event = { "BufReadPre", "BufNewFile" },
  event = { "BufReadPre", "BufReadPost", "BufNewFile" },
  config = function()
    -- indent
    local mini_indent = require("mini.indentscope")
    mini_indent.setup({
      -- symbol = "│",
      symbol = "▏",
      draw = { priority = 3 },
      options = { try_as_border = true, border = "both", indent_at_cursor = true },
      mappings = {
        object_scope = "ii",
        object_scope_with_border = "ai",
        goto_top = "[i",
        goto_bottom = "]i",
      },
    })
  end,
  -- keep this plugin separate to ensure we don't draw indent lines in certain buffers
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "alpha",
        "dashboard",
        "fzf",
        "help",
        "lazy",
        "lazyterm",
        "mason",
        "neo-tree",
        "notify",
        "toggleterm",
        "fterm",
        "Trouble",
        "trouble",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
