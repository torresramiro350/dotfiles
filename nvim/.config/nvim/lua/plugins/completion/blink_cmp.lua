return {
  "saghen/blink.cmp",
  enabled = false,
  event = { "InsertEnter" },
  -- event = { "LspAttach" },
  dependencies = "rafamadriz/friendly-snippets",
  nerd_font_variant = "normal",
  version = "v0.*",
  opts = {
    accept = { auto_brackets = { enable = true } },
    highlight = {
      use_nvim_cmp_as_default = true,
    },
    keymap = {
      ["<C-d>"] = { "hide" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
  },
}
