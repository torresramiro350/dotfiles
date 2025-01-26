return {
  "echasnovski/mini.snippets",
  event = "InsertEnter",
  dependencies = "rafamadriz/friendly-snippets",
  version = false,
  opts = function()
    local mini_snippets = require("mini.snippets")
    local expand_select_override = function(snippets, insert)
      -- stylua: ignore
      if cmp.visible() then cmp.close() end
      MiniSnippets.default_select(snippets, insert)
    end
    local ret = {
      snippets = { mini_snippets.gen_loader.from_lang() },
      expand = {
        select = function(snippets, insert)
          -- Close completion window on snippet select - vim.ui.select
          -- Needed to remove virtual text for fzf-lua and telescope, but not for mini.pick...
          local select = expand_select_override or MiniSnippets.default_select
          select(snippets, insert)
        end,
      },
    }
    return ret
  end,
}
