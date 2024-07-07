return {
  "echasnovski/mini.nvim",
  version = false,
  event = { "InsertEnter", "BufReadPre", "BufNewFile" },
  config = function()
    -- icons
    -- TODO: maybe later
    -- require("mini.icons").setup({
    --   style = "glyph",
    -- })

    -- pairs
    require("mini.pairs").setup()

    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - "va")  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote

    -- Better text objects
    require("mini.ai").setup({
      n_lines = 500,
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
        goto_left = "g[",
        goto_right = "g]",
      },
    })

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require("mini.surround").setup({
      mappings = {
        add = "sa",
        delete = "ds",
        find = "sf",  -- find surrounding to the right
        find_left = "sF", -- find surrounding to the left
        replace = "rs",
        highlight = "sh",
      },
      n_lines = 500,
    })
  end,
}
