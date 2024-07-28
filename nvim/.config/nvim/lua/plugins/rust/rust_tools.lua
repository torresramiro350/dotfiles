require("groups.utility_funcs")
return {

  "mrcjkb/rustaceanvim",
  priority = 1000,
  version = "^5", -- Recommended
  ft = { "rust" },
  config = function()
    vim.g.rustaceanvim = {
      float_win_config = {
        auto_focus = true,
        open_split = "vertical",
      },
      -- Plugin configuration
      tools = {},
      -- LSP configuration
      server = {
        -- on_attach = vim.g.rustaceanvim.server.on_attach,
        on_attach = function(client, bufnr)
          -- you can also put keymaps in here
          -- stylua: ignore start
          nmap(
            "n", "<leader>ca", function() vim.cmd.RustLsp("codeAction") end,
            { silent = true, buffer = bufnr }
          )
          nmap("n", "<s-k>", function() vim.cmd.RustLsp({ "hover", "actions" }) end)
          nmap(
            "n", "<leader>e", function() vim.cmd.RustLsp({ 'explainError', 'cycle' }) end,
            { desc = "Open [F]loating [D]iagnostic message" }
          )
          nmap("n", "<leader>df", function() vim.cmd.RustLsp("explainError") end)
          -- stylua: ignore stop
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
          },
          -- Add clippy lints for Rust
          checkOnSave = true,
          procMacro = {
            enable = true,
            ignored = {
              ["async-trait"] = { "async_trait" },
              ["napi-derive"] = { "napi" },
              ["async-recursion"] = { "async_recursion" },
            },
          },
        },
      },
      -- DAP configuration
      dap = {},
    }
  end,
}
