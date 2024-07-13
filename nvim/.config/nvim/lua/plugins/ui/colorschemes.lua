return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    local cat = require("catppuccin")
    -- local mocha = require("catppuccin.palettes").get_palette("mocha")
    cat.setup({
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false,
      styles = {             -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = { "italic" },
        functions = { "italic" },
        keywords = { "italic" },
        types = { "italic" },
        properties = { "italic" },
      },
      indent_blankline = {
        enabled = true,
        scope_color = "lavender",
        color_indent_levels = true,
      },
      integrations = {
        --defaults
        cmp = true,
        dap = true,
        flash = true,
        fidget = true,
        gitsigns = true,
        gitgutter = true,
        harpoon = true,
        headlines = true,
        illuminate = {
          enabled = true,
          lsp = false,
        },
        mason = true,
        mini = {
          enabled = true,
          -- indentscope_color = "",
          indentscope_color = function(mocha)
            return mocha.lavender
          end,
        },
        navic = {
          enabled = true,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        noice = true,
        neotree = true,
        neogit = true,
        notify = true,
        octo = true,
        rainbow_delimiters = true,
        telescope = true,
        lsp_trouble = true,
        treesitter = true,
        ts_rainbow = true,
        which_key = true,
        ufo = true,
      },
      highlight_overrides = {
        mocha = function(mocha)
          -- return { LineNr = { fg = mocha.lavender } }
          return { LineNr = { fg = mocha.overlay0 } }
        end,
      },
    })
  end,
}
