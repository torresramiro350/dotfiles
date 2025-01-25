require("groups.utility_funcs")
return {
  "stevearc/oil.nvim",
  enabled = false,
  event = { "BufRead", "BufNewFile", "BufReadPost" },
  -- opts = {},
  config = function()
    nmap("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    require("oil").setup({
      skip_confirm_for_simple_edits = true,
      win_options = { wrap = true },
      -- Your settings here
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
    })
  end,
  -- Optional dependencies
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
}
