return {
  "echasnovski/mini.snippets",
  event = "InsertEnter",
  dependencies = "rafamadriz/friendly-snippets",
  opts = function()
    local snippets = require("mini.snippets")
    local ret = { snippets = { snippets.gen_loader.from_lang() } }
    return ret
  end,
}
