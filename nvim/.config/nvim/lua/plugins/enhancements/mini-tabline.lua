return {
  "echasnovski/mini.tabline",
  version = false,
  event = { "BufNewFile", "BufReadPre" },
  config = function()
    local tabline = require("mini.tabline")
    tabline.setup({
      show_icons = true,
      set_vim_settings = true,
      tabpage_section = "left",
    })
  end,
}
