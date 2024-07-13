-- Useful plugin to show you pending keybinds.
return {
  "folke/which-key.nvim",
  config = function()
    local whichkey = require("which-key")
    -- document existing key chains
    -- deprecated way of adding keymappings (will remove later)
    -- whichkey.register({
    --   ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
    --   ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
    --   ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
    --   ["<leader>h"] = { name = "More git", _ = "which_key_ignore" },
    --   ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
    --   ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
    --   ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
    --   ["<leader>p"] = { name = "[P]ull Request", _ = "which_key_ignore" },
    -- })

    whichkey.add({
      { "<leader>c", group = "[C]ode" },
      { "<leader>d", group = "[D]ocument" },
      { "<leader>g", group = "[G]it" },
      { "<leader>i", group = "[G]it Issue" },
      { "<leader>h", group = "[H]unk Actions" },
      { "<leader>r", group = "[R]ename" },
      { "<leader>s", group = "[S]earch" },
      { "<leader>w", group = "[W]orkspace" },
      { "<leader>p", group = "[P]ull Request" },
    })

    whichkey.setup({
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3,                -- spacing between columns
        align = "center",           -- align columns left, center or right
      },
      win = {
        border = "single",
        -- position = "bottom",  -- bottom, top
        -- margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
        padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
        wo = {
          winblend = 10,      -- value between 0-100 0 for fully opaque and 100 for fully transparent
        },
        zindex = 1000,        -- positive value to position WhichKey above other floating windows.
      },
    })
  end,
  event = "VimEnter",
}
