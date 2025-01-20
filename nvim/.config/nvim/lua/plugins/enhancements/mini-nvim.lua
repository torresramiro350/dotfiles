return {
  {
    "echasnovski/mini.nvim",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- mini.comment
      local minicomment = require("mini.comment")
      local ts_context = require("ts_context_commentstring.internal")
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
      -- snippets
      local gen_loader = require("mini.snippets").gen_loader
      require("mini.snippets").setup({
        snippets = {
          gen_loader.from_file("~/.config/nvim/snippets/global.json"),

          -- Load snippets based on current language by reading files from
          -- "snippets/" subdirectories from 'runtimepath' directories.
          gen_loader.from_lang(),
        },
      })
      -- pairs
      require("mini.pairs").setup({
        modes = { insert = true, command = true, terminal = false },
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        skip_ts = { "string" },
        skip_unbalanced = true,
        markdown = true,
      })
      -- Better Around/Inside textobjects
      -- Examples:
      --  - "va")  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      -- Better text objects
      local ai = require("mini.ai")
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({
            a = { "@function.outer" },
            i = { "@function.inner" },
          }),
          c = ai.gen_spec.treesitter({
            a = { "@class.outer" },
            i = { "@class.inner" },
          }),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" },
          e = {
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
        },
        mappings = {
          -- Main textobject prefixes
          around = "a",
          inside = "i",
          -- Next/last variants
          around_next = "an",
          inside_next = "in",
          around_last = "al",
          inside_last = "il",
          goto_left = "[g",
          goto_right = "]g",
        },
      })
    end,
  },
}
