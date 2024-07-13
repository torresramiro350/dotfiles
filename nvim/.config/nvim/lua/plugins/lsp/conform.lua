return {
  "stevearc/conform.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        yaml = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        markdown = { "markdownlint" },
        cmake = { "cmake_format" },
        python = function(bufnr)
          if conform.get_formatter_info("ruff_format", bufnr).available then
            -- return { "ruff_format" } -- not supported by ruff as of yet
            return { "isort", "ruff_format" }
          else
            return { "isort", "black" }
          end
        end,
        sh = { "shfmt" },
        toml = { "taplo" },
        tex = { "latexindent" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end,
}
