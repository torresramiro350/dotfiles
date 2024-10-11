return {
  -- {
  --   "echasnovski/mini.tabline",
  --   version = false,
  --   event = { "BufNewFile", "BufReadPre" },
  --   config = function()
  --     local tabline = require("mini.tabline")
  --     tabline.setup({
  --       show_icons = true,
  --       set_vim_settings = true,
  --       tabpage_section = "left",
  --     })
  --   end,
  -- },
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
            -- return ts_context.calculate_commentstring() or vim.bo.commentstring
            return ts_context.calculate_commentstring() or vim.bo.commentstring
          end,
        },
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Toggle comment (like `gcip` - comment inner paragraph) for both
          -- Normal and Visual modes
          comment = "gc",

          -- Toggle comment on current line
          comment_line = "gcc",

          -- Toggle comment on visual selection
          comment_visual = "gc",

          -- Define 'comment' textobject (like `dgc` - delete whole comment block)
          -- Works also in Visual mode if mapping differs from `comment_visual`
          textobject = "gc",
        },
      })

      -- pairs
      require("mini.pairs").setup({
        modes = { insert = true, command = true, terminal = false },
        -- skip autopair when next character is one of these
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        -- skip autopair when the cursor is inside these treesitter nodes
        skip_ts = { "string" },
        -- skip autopair when next character is closing pair
        -- and there are more closing pairs than opening pairs
        skip_unbalanced = true,
        -- better deal with markdown code blocks
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
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" },                                           -- digits
          e = {                                                          -- Word with case
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(),                      -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
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

          -- Move cursor to corresponding edge of `a` textobject
          goto_left = "[g",
          goto_right = "]g",
        },
      })
    end,
  },
  {
    "echasnovski/mini.surround",
    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",  -- find surrounding to the right
        find_left = "gsF", -- find surrounding to the left
        replace = "gsr",
        highlight = "gsh",
        update_n_lines = "gsn",
      },
      search_method = "cover",
      n_lines = 20,
    },
  },
}
