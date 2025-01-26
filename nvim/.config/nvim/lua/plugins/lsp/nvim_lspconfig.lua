return {
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  event = { "BufNewFile", "BufReadPre", "BufReadPost" },
  opts = {
    servers = {
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = "LuaJit" },
            workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
            telemetry = { enable = false },
            codeLens = { enable = true },
            completion = {
              callSnippet = "Replace",
            },
            doc = {
              privateName = { "^_" },
            },
            hint = {
              enable = true,
              setType = false,
              paramType = true,
              paramName = "Disable",
              semicolon = "Disable",
              arrayIndex = "Disable",
            },
          },
        },
        filetypes = { "lua" },
        cmd = { "lua-language-server" },
        single_file_support = true,
      },
      pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        settings = {
          python = {
            analysis = {
              -- Ignore all files for analysis to exclusively use Ruff for linting
              ignore = { "*" },
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
            },
          },
        },
        single_file_support = true,
      },
      ruff = {
        cmd_env = { RUFF_TRACE = "messages" },
        init_options = {
          settings = {
            logLevel = "error",
          },
        },
        keys = {
          -- {
          --   "<leader>co",
          --   vim.lsp.buf.code_action["source.organizeImports"],
          --   -- vim.lsp.action["source.organizeImports"],
          --   desc = "Organize Imports",
          -- },
        },
      },
      clangd = {
        filetypes = { "c", "cxx", "h", "hxx", "objc", "objcpp", "cuda", "proto" },
        keys = {
          { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
        },
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders = true,
          completeunimported = true,
          clangdFileStatus = true,
        },
      },
      bashls = {
        filetypes = { "sh" },
      },
      neocmake = {},
      markdown_oxide = {},
      jsonls = { filetypes = { "json" } },
      yamlls = { filetypes = { "yaml", "yml" } },
      julials = {
        filetypes = { "julia" },
      },
      -- vimls = {},
      taplo = {
        filetypes = { "toml" },
      },
    },
  },
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup({})
      end,
      event = "VeryLazy",
    },
    {
      "williamboman/mason-lspconfig.nvim",
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = { "lua_ls" },
        })
      end,
    },
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "saghen/blink.cmp" },
    -- { "hrsh7th/cmp-nvim-lsp" },
    -- Useful status updates for LSP
    { "j-hui/fidget.nvim" },
  },
  config = function()
    --import lspconfig plugin
    -- local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local lspconfig = require("lspconfig")
    local navic = require("nvim-navic")
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    local on_attach = function(client, bufnr)
      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end

      local nmap = function(keys, func, desc)
        if desc then
          desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end
      -- local builtins = require("telescope.builtin")
      local function diagnostic_goto(direction, severity)
        local go = vim.diagnostic["goto_" .. (direction and "next" or "prev")]
        if type(severity) == "string" then
          severity = vim.diagnostic.severity[severity]
        end
        return function()
          go({ severity = severity })
        end
      end

      -- allow inlay hints for clangd
      local group = vim.api.nvim_create_augroup("clangd_no_inlay_hints_insert", { clear = true })
      nmap("<leader>lh", function()
        -- if require("clangd.extensions.inlay_hints")
        if require("clangd_extensions.inlay_hints").toggle_inlay_hints() then
          vim.api.nvim_create_autocmd("InsertEnter", {
            group = group,
            buffer = bufnr,
            callback = require("clangd_extensions.inlay_hints").disable_inlay_hints,
          })
          vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
            group = group,
            buffer = bufnr,
            callback = require("clangd_extensions.inlay_hints").set_inlay_hints,
          })
        else
          vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
        end
      end, "[l]sp [h]ints toggle")

      nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
      -- nmap("gd", builtins.lsp_definitions, "[G]oto [D]efinition")
      -- nmap("gr", builtins.lsp_references, "[G]oto [R]eferences")
      -- nmap("gI", builtins.lsp_implementations, "[G]oto [I]mplementation")
      -- nmap("gy", builtins.lsp_type_definitions, "Type [D]efinition")
      -- nmap("<leader>ds", builtins.lsp_document_symbols, "[D]ocument [S]ymbols")
      -- nmap("<leader>Ws", builtins.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

      -- See `:help K` for why this keymap
      nmap("K", vim.lsp.buf.hover, "Hover Documentation")
      nmap("<leader>k", vim.lsp.buf.signature_help, "Signature Documentation")

      -- Diagnostic keymaps
      nmap("[d", diagnostic_goto(false), "Go to previous diagnostic message")
      nmap("]d", diagnostic_goto(true), "Go to next diagnostic message")

      nmap("[e", diagnostic_goto(false, "ERROR"), "Go to previous error")
      nmap("]e", diagnostic_goto(true, "ERROR"), "Go to next error")
      nmap("[w", diagnostic_goto(false, "WARN"), "Go to previous warning")
      nmap("]w", diagnostic_goto(true, "WARN"), "Go to next warning")

      -- nmap("[q", vim.cmd.cprev, "Go to previous quickfix item")
      -- nmap("]q", vim.cmd.cnext, "Go to next quickfix item")
      nmap("]Q", vim.cmd.clast, "End of quickfix list")
      nmap("[Q", vim.cmd.cfirst, "Beginning of quickfix list")

      nmap("[l", vim.cmd.lnext, "Next loclist")
      nmap("]l", vim.cmd.lprev, "Previous loclist")
      nmap("]L", vim.cmd.llast, "End of loclist")
      nmap("[L", vim.cmd.lfirst, "Beginning of loclist")

      nmap("<leader>e", vim.diagnostic.open_float, "Open [F]loating [D]iagnostic message")

      -- stylua: ignore start
      nmap("<leader>xl", vim.diagnostic.setloclist, "Open [D]iagnostics [L]ist")
      nmap("<leader>xq", vim.diagnostic.setqflist, "Open [Q]uickfix [L]ist")
      -- stylua: ignore end
      nmap("<leader>Q", "<cmd>cclose<cr>", "Close quickfix list")
      nmap("<leader>L", "<cmd>lclose<cr>", "Close location list")

      -- Lesser used LSP functionality
      nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      nmap("<leader>Wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
      nmap("<leader>Wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
      nmap("<leader>Wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, "[W]orkspace [L]ist Folders")

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
      end, { desc = "Format current buffer with LSP" })
      nmap("<leader>lf", "<cmd>Format<cr>", "[L]format")
    end

    local ruff_attach = function(client, bufnr)
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    --
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- julia
    lspconfig.julials.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure python server
    -- since it's in alpha stage, we need to use the ruff-lsp server
    lspconfig.ruff.setup({
      capabilities = capabilities,
      on_attach = ruff_attach,
    })

    -- pyright
    lspconfig.pyright.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
    --bash
    lspconfig.bashls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- cmake
    lspconfig.neocmake.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    -- markdown
    lspconfig.markdown_oxide.setup({
      on_attach = on_attach,
      capabilities = vim.tbl_deep_extend("force", capabilities, {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true,
          },
        },
      }),
    })

    -- C/C++
    lspconfig.clangd.setup({
      capabilities = {
        capabilities,
        offsetEncoding = "utf-8",
      },
      on_attach = on_attach,
    })

    -- json
    lspconfig.jsonls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- yaml
    lspconfig.yamlls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Lua
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- TOML
    lspconfig.taplo.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- autoformat.lua
    -- Use your language server to automatically format your code on save.
    -- Adds additional commands as well to manage the behavior
    local format_is_enabled = true
    vim.api.nvim_create_user_command("FormatToggle", function()
      format_is_enabled = not format_is_enabled
      print("Setting autoformatting to: " .. tostring(format_is_enabled))
    end, {})

    -- Create an augroup that is used for managing our formatting autocmds.
    -- We need one augroup per client to make sure that multiple clients
    -- can attach to the same buffer without interfering with each other.
    local _augroups = {}
    local get_augroup = function(client)
      if not _augroups[client.id] then
        local group_name = "lsp-format-" .. client.name
        local id = vim.api.nvim_create_augroup(group_name, { clear = true })
        _augroups[client.id] = id
      end

      return _augroups[client.id]
    end

    -- Whenever an LSP attaches to a buffer, we will run this function.
    -- See `:help LspAttach` for more information about this autocmd event.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach-format", { clear = true }),
      -- This is where we attach the autoformatting for reasonable clients
      callback = function(args)
        local client_id = args.data.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        local bufnr = args.buf

        -- Only attach to clients that support document formatting
        if not client.server_capabilities.documentFormattingProvider then
          return
        end

        -- Create an autocmd that will run *before* we save the buffer.
        --  Run the formatting command for the LSP that has just attached.
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = get_augroup(client),
          buffer = bufnr,
          callback = function()
            if not format_is_enabled then
              return
            end

            vim.lsp.buf.format({
              async = false,
              filter = function(c)
                return c.id == client.id
              end,
            })
          end,
        })
      end,
    })
  end,
}
