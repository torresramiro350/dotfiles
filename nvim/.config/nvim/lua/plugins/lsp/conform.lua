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
        markdown = { "markdownlint", "markdown-toc" },
        cmake = { "cmake_format" },
        python = function(bufnr)
          if conform.get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_fix", "ruff_format", "ruff_organize_imports" }
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
