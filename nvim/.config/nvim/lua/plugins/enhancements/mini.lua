return {
  "echasnovski/mini.nvim",
  version = false,
  event = { "InsertEnter", "BufReadPre", "BufNewFile" },
  config = function()
    -- icons
    -- TODO: maybe later
    require("mini.icons").setup({
      style = "glyph",
    })
    --
    local ts_context = require("ts_context_commentstring.internal")
    require("mini.comment").setup({
      custom_commentstring = function()
        return ts_context.calculate_commentstring() or vim.bo.commentstring
      end,
    })

    -- pairs
    require("mini.pairs").setup()

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
          "Trouble",
          "trouble",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end
    -- indent
    -- local mini_indent = require("mini.indentscope")
    -- mini_indent.setup({
    --   draw = {
    --     animation = mini_indent.gen_animation.none(),
    --   },
    --   symbol = "│",
    --   options = { try_as_border = true },
    --   mappings = {
    --     -- Textobjects
    --     object_scope = "ii",
    --     object_scope_with_border = "ai",
    --
    --     -- Motions (jump to respective border line; if not present - body line)
    --     goto_top = "[i",
    --     goto_bottom = "]i",
    --   },
    -- })

    -- Better Around/Inside textobjects
    --
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
        d = { "%f[%d]%d+" },                                            -- digits
        e = {                                                           -- Word with case
          { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
          "^().*()$",
        },
        u = ai.gen_spec.function_call(),                       -- u for "Usage"
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

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require("mini.surround").setup({
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",  -- find surrounding to the right
        find_left = "gsF", -- find surrounding to the left
        replace = "gsr",
        highlight = "gsh",
      },
      n_lines = 500,
    })
  end,
}
