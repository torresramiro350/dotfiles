return {
  "saghen/blink.cmp",
  dependencies = {
    "echasnovski/mini.snippets",
    -- "rafamadriz/friendly-snippets",
    -- "Exafunction/codeium.nvim",
    -- "saghen/blink.compat",
  },
  event = "InsertEnter",
  enabled = true,
  version = "*",
  -- build = "cargo build --release",
  opts_extend = {
    "sources.completion.enabled_providers",
    "sources.compat",
    "sources.default",
  },
  opts = {
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "normal",
      -- nerd_font_variant = "mono",
    },
    completion = {
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
        },
      },
      list = {
        cycle = {
          from_bottom = true,
          from_top = true,
        },
      },
      ghost_text = {
        enabled = vim.g.ai_cmp,
      },
      menu = {
        auto_show = true,
        draw = {
          padding = 1,
          treesitter = { "lsp" },
          columns = {
            { "label",     "label_description", gap = 1 },
            { "kind_icon", "kind" },
          },
        },
        border = "padded",
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        update_delay_ms = 50,
        treesitter_highlighting = true,
      },
    },
    signature = {
      -- NOTE: this feature is experimental and may change in the future,
      -- so I'll leave it as disabled for now
      enabled = false,
    },
    snippets = { preset = "mini_snippets" },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      -- compat = { "codeium" },
      -- providers = {
      --   codeium = {
      --     kind = "Codeium",
      --     score_offset = 100,
      --     async = true,
      --   },
      -- },
      cmdline = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        -- Commands
        if type == ":" or type == "@" then
          return { "cmdline" }
        end
        return {}
      end,
    },
    keymap = {
      ["<C-y>"] = { "select_and_accept" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
  },
}
