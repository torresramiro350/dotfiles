return {
  "freddiehaddad/feline.nvim",
  enabled = true,
  event = "ColorScheme",
  config = function()
    local ctp_feline = require("catppuccin.groups.integrations.feline")
    local clrs = require("catppuccin.palettes").get_palette()
    local U = require("catppuccin.utils.colors")
    local mocha = require("catppuccin.palettes").get_palette("mocha")
    ctp_feline.setup({
      assets = {
        lsp = {
          server = "",
          error = "",
          warning = "",
          info = "",
          hint = "",
        },
        git = {
          branch = "",
          added = "",
          changed = "",
          removed = "",
        },
      },
      --- default setup
      sett = {
        text = U.vary_color({ mocha = mocha.base }, clrs.surface0),
        bkg = U.vary_color({ mocha = mocha.crust }, clrs.surface0),
        diffs = clrs.mauve,
        extras = clrs.overlay1,
        curr_file = clrs.maroon,
        curr_dir = clrs.flamingo,
        show_modified = true, -- show if the file has been modified
        show_lazy_updates = true, -- show the count of updatable plugins from lazy.nvim
        -- need to set checker.enabled = true in lazy.nvim first
        -- the icon is set in ui.icons.plugin in lazy.nvim
      },
      -- inactive = {
      --   "file_info",
      -- },
      view = {
        lsp = {
          progress = true,
          name = true,
          separator = "|",
          exclude_lsp_names = { "null-ls", "GitHub Copilot" },
        },
      },
    })

    require("feline").setup({
      components = ctp_feline.get(),
    })

    -- require("feline").setup({})
    -- require("feline").winbar.setup() -- to use winbar
    -- require("feline").statuscolumn.setup() -- to use statuscolumn
  end,
}
