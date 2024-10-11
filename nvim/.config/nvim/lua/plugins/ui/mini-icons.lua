return {
  "echasnovski/mini.icons",
  -- event = "VimEnter",
  lazy = true,
  files = {
    ["bash.tmpl"] = { glyph = "", hl = "MiniIconsGreen" },
    ["json.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
    ["ps1.tmpl"] = { glyph = "󰨊", hl = "MiniIconsGrey" },
    ["sh.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
    ["toml.tmpl"] = { glyph = "", hl = "MiniIconsRed" },
    ["yaml.tmpl"] = { glyph = "", hl = "MiniIconsRed" },
    ["zsh.tmpl"] = { glyph = "", hl = "MiniIconsGreen" },
  },
  config = function()
    local icons = require("mini.icons")
    icons.setup({
      style = "glyph",
    })
    -- replace web devicons with mini icons
    MiniIcons.mock_nvim_web_devicons()
  end,
  -- init = function()
  -- package.preload["nvim-web-devicons"] = function()
  --   icons.mock_nvim_web_devicons()
  --   return package.loaded["nvim-web-devicons"]
  -- end
  -- end,
}
