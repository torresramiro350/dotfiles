return {
  "saghen/blink.cmp",
  dependencies = "rafamadriz/friendly-snippets",
  -- use a release tag to download pre-built binaries
  version = "*",

  opts = {
    keymap = { preset = "default" },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "normal",
    },
    signature = { enabled = true },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      -- optionally disable cmdline completions
      -- cmdline = {},
    },

    keymap = {
      --   preset = 'default',
      --   -- disable a keymap from the preset
      --   ['<C-e>'] = {},
      --
      --   -- show with a list of providers
      --   ['<C-space>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },
      --
      --   -- note that your function will often be run in a "fast event" where most vim.api functions will throw an error
      --   -- you may want to wrap your function in `vim.schedule` or use `vim.schedule_wrap`
      --   ['<C-space>'] = { function(cmp) vim.schedule(function() your_behavior end) },
      --
      --   -- optionally, define different keymaps for cmdline
      --   cmdline = {
      --     preset = 'super-tab'
      --   }
      -- }
      --
      -- When defining your own keymaps without a preset, no keybinds will be assigned automatically.
      --
      -- Available commands:
      --   show, hide, cancel, accept, select_and_accept, select_prev, select_next, show_documentation, hide_documentation,
      --   scroll_documentation_up, scroll_documentation_down, snippet_forward, snippet_backward, fallback
      --
      -- "default" keymap
      --   ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      --   ['<C-e>'] = { 'hide' },
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
  opts_extend = { "sources.default" },
}
