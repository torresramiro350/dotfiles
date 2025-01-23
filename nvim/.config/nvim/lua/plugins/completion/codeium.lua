require("groups.utility_funcs")
return {
  "Exafunction/codeium.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  enabled = true,
  event = { "InsertEnter" },
  build = ":Codeium Auth",
  opts = {
    enable_cmp_source = not vim.g.ai_cmp,
    virtual_text = {
      enabled = vim.g.ai_cmp,
      key_bindings = {
        accept = "<Tab>", -- handled by nvim-cmp / blink.cmp
        next = "<M-]>",
        prev = "<M-[>",
      },
    },
  },
}
