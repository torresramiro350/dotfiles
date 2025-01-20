return {
  -- Autocompletion
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  enabled = false,
  dependencies = {
    {
      "garymjr/nvim-snippets",
      opts = {
        friendly_snippets = true,
      },
      dependencies = {
        "rafamadriz/friendly-snippets",
      },
    },
    -- Snippet Engine & its associated nvim-cmp source
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",           -- source for file system paths
    "hrsh7th/cmp-buffer",         -- source for text in buffer
    "rafamadriz/friendly-snippets", -- vs-code like picograms
    "onsails/lspkind.nvim",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local neogen = require("neogen")
    -- local lspkind = require("lspkind")
    require("luasnip.loaders.from_vscode").lazy_load()
    luasnip.config.setup({})
    luasnip.add_snippets(require("cppguard").snippet_luasnip("guard"))
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

    -- sets up auto completion for the command line
    cmp.setup.cmdline({ "/", "?" }, {
      -- mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
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
      auto_brackets = { "python" },
      view = {
        entries = { name = "custom", selection_order = "near_cursor" },
      },
      window = {
        -- completion = {
        --   winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        --   col_offset = -3,
        --   side_padding = 0,
        -- },
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
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
          require("clangd_extensions.cmp_scores"),
        },
      },
      completion = {
        completeopt = "menu,menuone,noinsert",
        border = "rounded",
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<C-CR>"] = function(fallback)
          cmp.abort()
          fallback()
        end,
        ["<S-CR>"] = function()
          return cmp.confirm(cmp.ConfirmBehavior.Replace)
        end,
        ["<CR>"] = function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = true })
          else
            fallback()
          end
        end,
        ["<C-l>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif neogen.jumpable() then
            neogen.jump_next()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          elseif neogen.jumpable(true) then
            neogen.jump_prev()
          end
        end, { "i", "s" }),
      }),
      -- source completion list
      sources = cmp.config.sources({
        {
          name = "lazydev",
          -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
          group_index = 0,
        },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        { name = "codeium", group_index = 1, priority = 100 }, -- in case we can no longer use copilot
      }),
      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        -- format = lspkind.cmp_format({
        --   mode = "symbol",
        -- }),
        format = function(entry, vim_item)
          -- replace with mini nvim icons
          local icon, hl, is_default = require("mini.icons").get("lsp", vim_item.kind)
          -- vim_item.kind = icon
          vim_item.kind = icon .. " " .. vim_item.kind
          vim_item.kind_hl_group = hl
          -- if icon ~= nil then
          --   vim_item.kind = icon
          -- end
          local widths = {
            abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
            menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
          }
          for key, width in pairs(widths) do
            if vim_item[key] and vim.fn.strdisplaywidth(vim_item[key]) > width then
              vim_item[key] = vim.fn.strcharpart(vim_item[key], 0, width - 1) .. "…"
            end
          end
          return vim_item
        end,
      },
    })
  end,
}
