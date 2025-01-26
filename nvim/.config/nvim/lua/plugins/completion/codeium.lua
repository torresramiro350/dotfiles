require("groups.utility_funcs")
return {
  "Exafunction/codeium.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  enabled = true,
  event = { "InsertEnter" },
  build = ":Codeium Auth",
  cmd = "Codeium",
  opts = {
    enable_cmp_source = vim.g.ai_cmp,
    virtual_text = {
      enabled = not vim.g.ai_cmp,
      key_bindings = {
        accept = false, -- handled by nvim-cmp / blink.cmp
        next = "<M-]>",
        prev = "<M-[>",
      },
    },
  },
}
