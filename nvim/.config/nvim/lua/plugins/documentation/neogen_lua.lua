require("groups.utility_funcs")
return {
  "danymat/neogen",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "BufNewFile ", "BufReadPre" },
  cmd = "Neogen",
  keys = {
    {
      "<leader>cn",
      function()
        require("neogen").generate()
      end,
      desc = "Generate annotations (Neogen)",
    },
  },
  config = function()
    local neogen = require("neogen")
    neogen.setup({
      -- snippet_engine = "luasnip",
      snippet_engine = "mini",
      input_after_comment = true,
      languages = {
        lua = {
          template = {
            -- annotation_convention = "emmylua",
            annotation_convention = "ldoc",
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
