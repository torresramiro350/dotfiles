return {
  -- Autocompletion
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    -- Adds LSP completion capabilities
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path", -- source for file system paths
    "hrsh7th/cmp-buffer", -- source for text in buffer

    -- Adds a number of user-friendly snippets
    "rafamadriz/friendly-snippets",
    -- vs-code like picograms
    "onsails/lspkind.nvim",
  },

  config = function()
    -- [[ Configure nvim-cmp ]]
    -- See `:help cmp`
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")
    require("luasnip.loaders.from_vscode").lazy_load()
    luasnip.config.setup({})

    -- sets up auto completion for the command line
    cmp.setup.cmdline({ "/", "?" }, {
      -- mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      -- mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })

    cmp.setup({
      view = {
        entries = { name = "custom", selection_order = "near_cursor" },
      },
      -- setup the window style for code completion (I like the window rounded style)
      -- with borders for both code completion and documentation
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      -- setup snopped completions
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      -- will update this with more information once I know what this is doing
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.exact,
          cmp.config.compare.recently_used,
          cmp.config.compare.offset,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      completion = {
        completeopt = "menu,menuone,noinsert",
        -- rounded style (my preference)
        border = "rounded",
      },
      -- setup some keybindings for the selection of code completions
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),

        -- <c-l> will move you to the right of each of the expansion locations.
        -- ["<C-l>"] = cmp.mapping(function()
        -- 	if luasnip.expand_or_locally_jumpable() then
        -- 		luasnip.expand_or_jump()
        -- 	end
        -- end, { "i", "s" }),
        -- -- <c-h> is similar, except moving you backwards.
        -- ["<C-h>"] = cmp.mapping(function()
        -- 	if luasnip.locally_jumpable(-1) then
        -- 		luasnip.jump(-1)
        -- 	end
        -- end, { "i", "s" }),
      }),
      -- source completion list
      sources = cmp.config.sources({
        { name = "nvim_lsp", group_index = 2 },
        { name = "buffer",   group_index = 2 },
        { name = "luasnip",  group_index = 2 },
        { name = "path",     group_index = 2 },
      }),
      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        format = lspkind.cmp_format({
          -- mode = "symbol_text",
          mode = "symbol",
        }),
        -- format = function(entry, vim_item)
        --   -- replace with mini nvim icons
        --   local icon, _ = require("mini.icons").get("lsp", vim_item.kind)
        --   if icon ~= nil then
        --     vim_item.kind = icon
        --   end
        --   return vim_item
        -- end,
      },
    })
  end,
}
