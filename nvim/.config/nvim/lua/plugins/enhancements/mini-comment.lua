return {
  "echasnovski/mini.comment",
  version = false,
  event = "BufReadPost",
  config = function()
    local minicomment = require("mini.comment")
    local ts_context = require("ts_context_commentstring.internal")
    -- mini.comment
    minicomment.setup({
      options = {
        custom_commentstring = function()
          return ts_context.calculate_commentstring() or vim.bo.commentstring
        end,
      },
      mappings = {
        comment = "gc",
        comment_line = "gcc",
        comment_visual = "gc",
        textobject = "gc",
      },
    })
  end,
}
