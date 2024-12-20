require("groups.utility_funcs")
return {
  "Exafunction/codeium.vim",
  enabled = true,
  event = { "InsertEnter" },
  build = ":Codeium Auth",
  config = function()
    -- Change '<C-g>' here to any keycode you like.
    -- stylua: ignore start
    nmap("i", "<tab>",
      function() return vim.fn["codeium#Accept"]() end, { expr = true, silent = true })
    nmap("i", "<c-;>",
      function() return vim.fn["codeium#CycleCompletions"](1) end,
      { expr = true, silent = true })
    nmap("i", "<c-,>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end,
      { expr = true, silent = true })
    nmap("i", "<c-x>", function() return vim.fn["codeium#Clear"]() end,
      { expr = true, silent = true })
    -- stylua: ignore end
  end,
}
