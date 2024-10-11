require("groups.utility_funcs")
return {
  "danymat/neogen",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "BufNewFile ", "BufReadPre", "InsertEnter" },
  cmd = "Neogen",
  keys = {
    {
      "<leader>nc",
      function()
        require("neogen").generate()
      end,
      desc = "Generate annotations (Neogen)",
    },
  },
  config = function()
    local neogen = require("neogen")
    neogen.setup({
      -- took this snipped from lazyvim's documentation
      opts = function(_, opts)
        if opts.snippet_engine ~= nil then
          return
        end
        local map = {
          ["LuaSnip"] = "luasnip",
          ["nvim-snippy"] = "snippy",
          ["vim-vsnip"] = "vsnip",
        }
        for plugin, engine in pairs(map) do
          if vim.fn.exists("*" .. plugin) == 1 then
            opts.snippet_engine = engine
          end
        end
        if vim.snippet then
          opts.snippet_engine = "nvim"
        end
      end,
      input_after_comment = true,
      languages = {
        lua = {
          template = {
            annotation_convention = "emmylua",
          },
        },
        python = {
          template = {
            annotation_convention = "reST",
            -- annotation_convention = "numpydoc",
          },
        },
        cpp = {
          template = {
            annotation_convention = "doxygen",
          },
        },
        rust = {
          template = {
            annotation_convention = "rustdoc",
          },
        },
        sh = {
          template = {
            annotation_convention = "google_bash",
          },
        },
      },
    })
  end,
}
