return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    input = { enabled = false },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    dashboard = {
      sections = {
        { section = "header" },
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
    },

    scope = {
      enabled = true,
      opts = {
        min_size = 2,
        cursor = true, -- column of the cursor is  used to determine the scope
        edge = true,  -- include the edge of the scope
        siblings = false, -- expand single line scopes with single line siblings
        debounce = 30, -- debounce scope detection in ms
        tresitter = {
          enabled = true,
          blocks = {
            enabled = true, -- enable to use the following blocks
            "function_declaration",
            "function_definition",
            "method_declaration",
            "method_definition",
            "class_declaration",
            "class_definition",
            "do_statement",
            "while_statement",
            "repeat_statement",
            "if_statement",
            "for_statement",
          },
          field_blocks = {
            "local_declaration",
          },
        },
        keys = {
          textobject = {
            ii = {
              min_size = 2, -- minimum size of the scope
              edge = false,
              cursor = false,
              tresitter = { blocks = { enabled = true } },
              desc = "inner scope",
            },
            ai = {
              cursor = false,
              min_size = 2, -- minimum size of the scope
              tresitter = { blocks = { enabled = true } },
              desc = "full scope",
            },
          },
          jump = {
            ["[i"] = {
              min_size = 1, -- allow single line scopes
              bottom = false,
              cursor = false,
              edge = true,
              tresitter = { blocks = { enabled = false } },
              desc = "jump to top edge of scope",
            },
            ["]i"] = {
              min_size = 1, -- allow single line scopes
              bottom = true,
              cursor = false,
              edge = true,
              tresitter = { blocks = { enabled = true } },
              desc = "jump to bottom edge of scope",
            },
          },
        },
      },
    },

    bigfile = { enabled = true },
    indent = {
      priority = 1,
      only_scope = true,
      only_current = true,
      enabled = true,
      chunk = {
        -- when enabled, scopes will be rendered as chunks, except for the
        -- top-level scope which will be rendered as a scope.
        enabled = true,
        -- only show chunk scopes in the current window
        only_current = false,
        priority = 200,
        hl = "SnacksIndentChunk",
        char = {
          -- corner_top = "┌",
          -- corner_bottom = "└",
          corner_top = "╭",
          corner_bottom = "╰",
          horizontal = "─",
          vertical = "│",
          arrow = ">",
        },
      },
    },
  },
  keys = {
    -- stylua: ignore start
    { "<leader>z",  function() Snacks.zen() end,                desc = "Toggle Zen Mode" },
    { "<leader>Z",  function() Snacks.zen.zoom() end,           desc = "Toggle Zoom" },
    { "<leader>.",  function() Snacks.scratch() end,            desc = "Toggle Scratch Buffer", },
    { "<leader>S",  function() Snacks.scratch.select() end,     desc = "Select Scratch Buffer" },
    { "<leader>bd", function() Snacks.bufdelete() end,          desc = "Delete Buffer", },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", },
    { "<leader>gB", function() Snacks.gitbrowse() end,          desc = "Git Browse", },
    { "<leader>gb", function() Snacks.git.blame_line() end,     desc = "Git Blame Line", },
    { "<leader>gf", function() Snacks.lazygit.log_file() end,   desc = "Lazygit Current File History" },
    { "<leader>gg", function() Snacks.lazygit() end,            desc = "Lazygit", },
    { "<leader>gl", function() Snacks.lazygit.log() end,        desc = "Lazygit Log (cwd)", },
    { "<c-/>",      function() Snacks.terminal() end,           desc = "Toggle Terminal", },
    {
      "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications",
    },
    {
      "]]",
      function() Snacks.words.jump(vim.v.count1) end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },
    {
      "[[",
      function() Snacks.words.jump(-vim.v.count1) end,
      desc = "Prev Reference",
      mode = { "n", "t" },
    },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
    -- {
    --   "<c-_>",
    --   function()
    --     Snacks.terminal()
    --   end,
    --   desc = "which_key_ignore",
    -- },
    -- stylua: ignore end
  },
  init = function()
    -- taken from snack.nvim github
    ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
    local progress = vim.defaulttable()
    vim.api.nvim_create_autocmd("LspProgress", {
      ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params
        .value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= "table" then
          return
        end
        local p = progress[client.id]

        for i = 1, #p + 1 do
          if i == #p + 1 or p[i].token == ev.data.params.token then
            p[i] = {
              token = ev.data.params.token,
              msg = ("[%3d%%] %s%s"):format(
                value.kind == "end" and 100 or value.percentage or 100,
                value.title or "",
                value.message and (" **%s**"):format(value.message) or ""
              ),
              done = value.kind == "end",
            }
            break
          end
        end

        local msg = {} ---@type string[]
        progress[client.id] = vim.tbl_filter(function(v)
          return table.insert(msg, v.msg) or not v.done
        end, p)

        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        vim.notify(table.concat(msg, "\n"), "info", {
          id = "lsp_progress",
          title = client.name,
          opts = function(notif)
            notif.icon = #progress[client.id] == 0 and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
          end,
        })
      end,
    })
    -- User autocmd
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle
            .option("background", { off = "light", on = "dark", name = "Dark Background" })
            :map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })
  end,
}
