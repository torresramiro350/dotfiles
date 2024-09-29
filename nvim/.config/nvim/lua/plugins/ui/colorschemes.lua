return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    local cat = require("catppuccin")
    -- local mocha = require("catppuccin.palettes").get_palette("mocha")
    cat.setup({
      background = {
        light = "latte",
        dark = "mocha",
      },
      flavour = "auto",
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = { "italic" },
        functions = { "italic" },
        keywords = { "italic" },
        types = { "italic" },
        properties = { "italic" },
      },
      indent_blankline = {
        enabled = true,
        -- scope_color = "lavender",
        color_indent_levels = true,
      },
      integrations = {
        --defaults
        alpha = true,
        barbecue = {
          dim_dirname = true, -- directory name is dimmed by default
          bold_basename = true,
          dim_context = false,
          alt_background = false,
        },
        cmp = true,
        diffview = true,
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
        markdown = true,
        render_markdown = true,
        mason = true,
        mini = {
          enabled = true,
          indentscope_color = "lavender",
          -- indentscope_color = "peach",
        },
        navic = {
          enabled = true,
          -- enabled = false,
          -- custom_bg = "NONE",
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
        nvim_surround = true,
        notify = true,
        octo = true,
        rainbow_delimiters = true,
        telescope = {
          enabled = true,
          -- style = "nvchad",
        },
        lsp_trouble = true,
        treesitter = true,
        ts_rainbow = true,
        which_key = true,
        ufo = true,
      },
      color_overrides = {
        mocha = {
          -- base = "#1e1e2e",
          -- base = "#181825",
        },
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
