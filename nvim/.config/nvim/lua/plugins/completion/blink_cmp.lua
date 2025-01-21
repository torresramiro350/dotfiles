return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "echasnovski/mini.snippets",
  },
  event = "InsertEnter",
  enabled = true,
  version = "*",
  opts = {
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
      -- nerd_font_variant = "normal",
    },
    completion = {
      list = {
        cycle = {
          from_bottom = true,
          from_top = true,
        },
      },
      ghost_text = {
        enabled = false,
        -- enabled = vim.g.ai_cmp,
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
        -- border = "single",
        border = "padded",
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        update_delay_ms = 50,
        treesitter_highlighting = true,
        window = {
          min_width = 10,
          max_width = 80,
          max_height = 15,
          border = "padded",
          -- border = "single",
          winblend = 0,
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
          scrollbar = true,
          -- Which directions to show the documentation window,
          -- for each of the possible menu window directions,
          -- falling back to the next direction when there's not enough space
          direction_priority = {
            menu_north = { "e", "w", "n", "s" },
            menu_south = { "e", "w", "s", "n" },
          },
        },
      },
    },
    signature = {
      -- NOTE: this feature is experimental and may change in the future, so I'll leave it
      -- as disabled for now
      enabled = false,
      window = {
        min_width = 1,
        max_width = 80,
        max_height = 15,
        border = "padded",
        winblend = 0,
        winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
        scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
        -- Which directions to show the window,
        -- falling back to the next direction when there's not enough space,
        -- or another window is in the way
        direction_priority = { "n", "s" },
        -- Disable if you run into performance issues
        treesitter_highlighting = true,
        -- show_documentation = true,
      },
    },
    -- snippets = { preset = "luasnip" },
    snippets = { preset = "mini_snippets" },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      -- cmdline = {},
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
