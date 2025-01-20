return {
  "echasnovski/mini.tabline",
  version = "*",
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
