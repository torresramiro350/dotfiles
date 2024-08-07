return {
  "kylechui/nvim-surround",
  enabled = false,
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  -- don't load the plugin until we start typing
  -- load once the file is read into buffer
  event = "InsertEnter",
  config = function()
    local nvim_surround_opts = require("nvim-surround")
    nvim_surround_opts.setup({
      -- Configuration here, or leave empty to use defaults
    })
  end,
}
