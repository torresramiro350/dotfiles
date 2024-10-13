-- import utility function to define keymaps
require("groups.utility_funcs")
-- Fuzzy Finder (files, lsp, etc)
return {
  {
    "crispgm/telescope-heading.nvim",
    ft = { "markdown", "vimwiki" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("telescope").load_extension("heading")
      nmap("n", "<leader>sH", "<cmd>Telescope heading<cr>", { desc = "[S]earch by [H]eading" })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    config = function()
      local actions = require("telescope.actions")
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
          heading = {
            treesitter = true,
            picker_opts = {
              layout_config = { width = 0.8, preview_width = 0.5 },
              layout_strategy = "horizontal",
            },
          },
        },
        defaults = {
          layout_config = {
            horizontal = { preview_cutoff = 80, preview_width = 0.55 },
            vertical = { mirror = true, preview_cutoff = 25 },
            prompt_position = "top",
            width = 0.87,
            height = 0.80,
          },
          sorting_strategy = "ascending",
          layout_strategy = "flex",
          mappings = {
            -- add mappings in insert mode
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
              ["<C-n>"] = {
                actions.move_selection_next,
                type = "action",
              },
              ["<C-p>"] = {
                actions.move_selection_previous,
                type = "action",
              },
            },
            -- add mappings in normal mode
            n = {
              ["q"] = {
                actions.close,
                type = "action",
              },
            },
          },
        },
      })

      -- Telescope live_grep in git root
      -- Function to find the git root directory based on the current buffer's path
      local function find_git_root()
        -- Use the current buffer's path as the starting point for the git search
        local current_file = vim.api.nvim_buf_get_name(0)
        local current_dir
        local cwd = vim.fn.getcwd()
        -- If the buffer is not associated with a file, return nil
        if current_file == "" then
          current_dir = cwd
        else
          -- Extract the directory from the current file's path
          current_dir = vim.fn.fnamemodify(current_file, ":h")
        end

        -- Find the Git root directory from the current file's path
        local git_root =
            vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
        if vim.v.shell_error ~= 0 then
          print("Not a git repository. Searching on current working directory")
          return cwd
        end
        return git_root
      end

      -- mappings
      local builtin = require("telescope.builtin")
      local tel = require("telescope")
      local tel_themes = require("telescope.themes")
      -- Enable telescope fzf native, if installed
      pcall(tel.load_extension, "fzf")

      -- Custom live_grep function to search in git root
      local function live_grep_git_root()
        local git_root = find_git_root()
        if git_root then
          builtin.live_grep({ search_dirs = { git_root } })
        end
      end

      vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

      -- stylua: ignore start
      nmap("n", "<leader><space>", function() builtin.buffers({ sort_mru = true, ignore_current_buffer = true }) end,
        { desc = "[ ] Find existing buffers" })
      nmap("n", "<leader>/",
        function()
          builtin.current_buffer_fuzzy_find(tel_themes.get_dropdown({ winblend = 10, previewer = false, }))
        end, {
          desc = "[/] Fuzzily search in current buffer",
        })
      nmap('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      nmap('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      nmap("n", "<leader>s/", builtin.live_grep, { desc = "[s/] Live grep in open files" })
      nmap("n", "<leader>?", function() builtin.oldfiles({ cwd = vim.uv.cwd() }) end,
        { desc = "[?] Find recently opened files" })
      nmap("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      nmap("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
      nmap("n", "<leader>gf", builtin.git_files, { desc = "Search [G]it [F]iles" })
      nmap("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      nmap("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      nmap("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      nmap("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      nmap("n", "<leader>sq", "<cmd>Telescope quickfix<cr>", { desc = "Quickfix List" })
      nmap("n", "<leader>sG", "<cmd>LiveGrepGitRoot<cr>", { desc = "[S]earch by [G]rep on Git Root" })
      -- stylua: ignore end
    end,
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        "nvim-tree/nvim-web-devicons",
        enabled = vim.g.have_nerd_font,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
  },
}
