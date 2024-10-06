return {
  {
    "echasnovski/mini.files",
    event = { "BufNewFile", "BufReadPre" },
    version = false,
    keys = {
      {
        "<leader>fm",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Open mini.files (Directory of Current File)",
      },
      {
        "<leader>fM",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        desc = "Open mini.files (cwd)",
      },
    },
    opts = {
      options = {
        -- Whether to use for editing directories
        use_as_default_explorer = false, -- use neotree for that
      },
      windows = {
        true,
        width_focus = 30,
        width_preview = 30,
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)

      local show_dotfiles = true
      local filter_show = function(fs_entry)
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end
      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require("mini.files").refresh({ content = { filter = new_filter } })
      end

      local map_split = function(buf_id, lhs, direction, close_on_file)
        local rhs = function()
          local new_target_window
          local cur_target_window = require("mini.files").get_explorer_state().target_window
          if cur_target_window ~= nil then
            vim.api.nvim_win_call(cur_target_window, function()
              vim.cmd("belowright " .. direction .. " split")
              new_target_window = vim.api.nvim_get_current_win()
            end)

            require("mini.files").set_target_window(new_target_window)
            require("mini.files").go_in({ close_on_file = close_on_file })
          end
        end

        local desc = "Open in " .. direction .. " split"
        if close_on_file then
          desc = desc .. " and close on file"
        end
        nmap("n", lhs, rhs, { buffer = buf_id, desc = desc })
      end
      local files_set_cwd = function()
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        if cur_directory ~= nil then
          vim.fn.chdir(cur_directory)
        end
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id

          nmap(
            "n",
            opts.mappings and opts.mappings.toggle_hidden or "g.",
            toggle_dotfiles,
            { buffer = buf_id, desc = "Toggle hidden files" }
          )
          nmap("n", opts.mappings and opts.mappings.change_cwd or "g,", files_set_cwd, {
            buffer = buf_id,
            desc = "Set cwd",
          })

          map_split(buf_id, opts.mappings and opts.mappings.go_in_horizontal or "<C-s>", "horizontal", false)
          map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical or "<C-v>", "vertical", false)
          map_split(
            buf_id,
            opts.mappings and opts.mappings.go_in_horizontal_plus or "<C-S>",
            "horizontal",
            true
          )
          map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical_plus or "<C-V>", "vertical", true)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event)
          local entry = event.data.from
          local new_name = event.data.to
          vim.fn.rename(entry.path, new_name)
        end,
      })
    end,
  },
  {
    "echasnovski/mini.tabline",
    version = false,
    event = { "BufNewFile", "BufReadPre" },
    config = function()
      local tabline = require("mini.tabline")
      tabline.setup({
        show_icons = true,
        set_vim_settings = true,
        tabpage_section = "left",
      })
    end,
  },
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- indent
      local mini_indent = require("mini.indentscope")
      mini_indent.setup({
        draw = {
          -- animation = mini_indent.gen_animation.none(),
        },
        symbol = "│",
        options = { try_as_border = true },
        mappings = {
          -- Textobjects
          object_scope = "ii",
          object_scope_with_border = "ai",

          -- Motions (jump to respective border line; if not present - body line)
          goto_top = "[i",
          goto_bottom = "]i",
        },
      })
    end,
    -- keep this plugin separate to ensure we don't draw indent lines in certain buffers
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "alpha",
          "dashboard",
          "fzf",
          "help",
          "lazy",
          "lazyterm",
          "mason",
          "neo-tree",
          "notify",
          "toggleterm",
          "fterm",
          "fish",
          "Trouble",
          "trouble",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    "echasnovski/mini.icons",
    version = false,
    event = "VimEnter",
    lazy = true,
    files = {
      ["bash.tmpl"] = { glyph = "", hl = "MiniIconsGreen" },
      ["json.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
      ["ps1.tmpl"] = { glyph = "󰨊", hl = "MiniIconsGrey" },
      ["sh.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
      ["toml.tmpl"] = { glyph = "", hl = "MiniIconsRed" },
      ["yaml.tmpl"] = { glyph = "", hl = "MiniIconsRed" },
      ["zsh.tmpl"] = { glyph = "", hl = "MiniIconsGreen" },
    },
    config = function()
      local icons = require("mini.icons")
      icons.setup({
        style = "glyph",
      })
      -- replace web devicons with mini icons
      MiniIcons.mock_nvim_web_devicons()
    end,
    -- init = function()
    -- package.preload["nvim-web-devicons"] = function()
    --   icons.mock_nvim_web_devicons()
    --   return package.loaded["nvim-web-devicons"]
    -- end
    -- end,
  },
  {
    "echasnovski/mini.nvim",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- mini.comment
      local minicomment = require("mini.comment")
      local ts_context = require("ts_context_commentstring.internal")
      minicomment.setup({
        options = {
          custom_commentstring = function()
            -- return ts_context.calculate_commentstring() or vim.bo.commentstring
            return ts_context.calculate_commentstring() or vim.bo.commentstring
          end,
        },
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Toggle comment (like `gcip` - comment inner paragraph) for both
          -- Normal and Visual modes
          comment = "gc",

          -- Toggle comment on current line
          comment_line = "gcc",

          -- Toggle comment on visual selection
          comment_visual = "gc",

          -- Define 'comment' textobject (like `dgc` - delete whole comment block)
          -- Works also in Visual mode if mapping differs from `comment_visual`
          textobject = "gc",
        },
      })

      -- pairs
      require("mini.pairs").setup({
        modes = { insert = true, command = true, terminal = false },
        -- skip autopair when next character is one of these
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        -- skip autopair when the cursor is inside these treesitter nodes
        skip_ts = { "string" },
        -- skip autopair when next character is closing pair
        -- and there are more closing pairs than opening pairs
        skip_unbalanced = true,
        -- better deal with markdown code blocks
        markdown = true,
      })

      -- Better Around/Inside textobjects
      -- Examples:
      --  - "va")  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      -- Better text objects
      local ai = require("mini.ai")
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({
            a = { "@function.outer" },
            i = { "@function.inner" },
          }),
          c = ai.gen_spec.treesitter({
            a = { "@class.outer" },
            i = { "@class.inner" },
          }),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" },                                           -- digits
          e = {                                                          -- Word with case
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(),                      -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
        mappings = {
          -- Main textobject prefixes
          around = "a",
          inside = "i",

          -- Next/last variants
          around_next = "an",
          inside_next = "in",
          around_last = "al",
          inside_last = "il",

          -- Move cursor to corresponding edge of `a` textobject
          goto_left = "[g",
          goto_right = "]g",
        },
      })
    end,
  },
  {
    "echasnovski/mini.surround",
    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",  -- find surrounding to the right
        find_left = "gsF", -- find surrounding to the left
        replace = "gsr",
        highlight = "gsh",
        update_n_lines = "gsn",
      },
      search_method = "cover",
      n_lines = 20,
    },
  },
  {
    "echasnovski/mini.statusline",
    version = false,
    event = { "VimEnter" },
    config = function()
      local statusline = require("mini.statusline")

      -- Autocmd to track macro recording, And redraw statusline, which trigger
      -- macro function of mini.statusline
      vim.api.nvim_create_autocmd("RecordingEnter", {
        pattern = "*",
        callback = function()
          vim.cmd("redrawstatus")
        end,
      })

      -- Autocmd to track the end of macro recording
      vim.api.nvim_create_autocmd("RecordingLeave", {
        pattern = "*",
        callback = function()
          vim.cmd("redrawstatus")
        end,
      })

      statusline.setup({
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local check_macro_recording = function()
              if vim.fn.reg_recording() ~= "" then
                return "recording @" .. vim.fn.reg_recording()
              else
                return ""
              end
            end

            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git = MiniStatusline.section_git({ trunc_width = 40 })
            local diff = MiniStatusline.section_diff({ trunc_width = 75 })
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
            local filename = MiniStatusline.section_filename({ trunc_width = 140 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location = MiniStatusline.section_location({ trunc_width = 75 })
            local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
            local macro = check_macro_recording()
            return MiniStatusline.combine_groups({
              { hl = mode_hl,                 strings = { mode } },
              { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
              "%<", -- Mark general truncate point
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=", -- End left alignment
              { hl = "MiniStatuslineFilename", strings = { macro } },
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = mode_hl,                  strings = { search, location } },
            })
          end,
        },
      })
    end,
  },
}
