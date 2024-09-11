return {
  {
    "echasnovski/mini.statusline",
    version = false,
    -- event = { "BufReadPre", "BufNewFile" },
    event = { "VimEnter" },
    config = function()
      local statusline = require("mini.statusline")
      -- Autocmd to track macro recording, And redraw statusline, which trigger
      -- macro function of mini.statusline
      vim.api.nvim_create_autocmd("RecordingEnter", {
        pattern = "*",
        callback = function()
          vim.cmd("redrawstatus")
        end,
      })

      -- Autocmd to track the end of macro recording
      vim.api.nvim_create_autocmd("RecordingLeave", {
        pattern = "*",
        callback = function()
          vim.cmd("redrawstatus")
        end,
      })

      statusline.setup({
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local check_macro_recording = function()
              if vim.fn.reg_recording() ~= "" then
                return "recording @" .. vim.fn.reg_recording()
              else
                return ""
              end
            end

            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git = MiniStatusline.section_git({ trunc_width = 40 })
            local diff = MiniStatusline.section_diff({ trunc_width = 75 })
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
            local filename = MiniStatusline.section_filename({ trunc_width = 140 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location = MiniStatusline.section_location({ trunc_width = 200 })
            local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
            local macro = check_macro_recording()
            return MiniStatusline.combine_groups({
              { hl = mode_hl,                 strings = { mode } },
              { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
              "%<", -- Mark general truncate point
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=", -- End left alignment
              { hl = "MiniStatuslineFilename", strings = { macro } },
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = mode_hl,                  strings = { search, location } },
            })
          end,
        },
      })
    end,
  },
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- indent
      local mini_indent = require("mini.indentscope")
      mini_indent.setup({
        draw = {
          -- animation = mini_indent.gen_animation.none(),
        },
        symbol = "│",
        options = { try_as_border = true, border = "both" },
        mappings = {
          -- Textobjects
          object_scope = "ii",
          object_scope_with_border = "ai",

          -- Motions (jump to respective border line; if not present - body line)
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
          "Fterm",
          "FTERM",
          "Trouble",
          "trouble",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    "echasnovski/mini.icons",
    lazy = true,
    config = function()
      local mini = require("mini.icons")
      mini.setup({
        style = "glyph",
      })
    end,
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
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
      require("mini.pairs").setup()

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

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup({
        mappings = {
          add = "gsa",
          delete = "gsd",
          find = "gsf", -- find surrounding to the right
          find_left = "gsF", -- find surrounding to the left
          replace = "gsr",
          highlight = "gsh",
          update_n_lines = "gsn",
        },
        n_lines = 500,
      })
    end,
  },
}
