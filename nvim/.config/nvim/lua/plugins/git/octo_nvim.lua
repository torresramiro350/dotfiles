require("groups.utility_funcs")
return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  event = { { event = "BufReadCmd", pattern = "octo://*" } },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    -- PRs
    { "<leader>gpa", "<cmd>Octo pr create<cr>",     desc = "Create PR" },
    { "<leader>gpl", "<cmd>Octo pr list<cr>",       desc = "PRs list" },
    { "<leader>gpa", "<cmd>Octo pr create<cr>",     desc = "Create PR" },
    { "<leader>gpo", "<cmd>Octo pr checkout<cr>",   desc = "Checkout PR" },
    { "<leader>gpd", "<cmd>Octo pr diff<cr>",       desc = "Show PR diff" },
    { "<leader>gpc", "<cmd>Octo pr commits<cr>",    desc = "List PR commits" },
    { "<leader>gpf", "<cmd>Octo pr changes<cr>",    desc = "List PR files" },
    { "<leader>gpm", "<cmd>Octo pr merge<cr>",      desc = "Merge PR" },
    -- Issues
    { "<leader>gil", "<cmd>Octo issue list<cr>",    desc = "List issues" },
    { "<leader>gio", "<cmd>Octo issue create<cr>",  desc = "Create issue" },
    { "<leader>gir", "<cmd>Octo issue reload<cr>",  desc = "Reload issue" },
    { "<leader>gic", "<cmd>Octo issue close<cr>",   desc = "Close issue" },
    { "<leader>gib", "<cmd>Octo issue browser<cr>", desc = "Open issue in browser" },
    { "<leader>a",   "",                            desc = "+assignee (Octo)",     ft = "octo" },
    { "<leader>c",   "",                            desc = "+comment/code (Octo)", ft = "octo" },
    { "<leader>l",   "",                            desc = "+label (Octo)",        ft = "octo" },
    { "<leader>i",   "",                            desc = "+issue (Octo)",        ft = "octo" },
    { "<leader>r",   "",                            desc = "+react (Octo)",        ft = "octo" },
    { "<leader>p",   "",                            desc = "+pr (Octo)",           ft = "octo" },
    { "<leader>v",   "",                            desc = "+review (Octo)",       ft = "octo" },
    { "@",           "@<C-x><C-o>",                 mode = "i",                    ft = "octo", silent = true },
    { "#",           "#<C-x><C-o>",                 mode = "i",                    ft = "octo", silent = true },
  },
  config = function()
    local octo = require("octo")
    octo.setup({
      enable_builtin = true,
      default_merge_method = "squash",
      picker = "telescope",
      picker_config = {
        checkout_pr = { lhs = "<C-o>", desc = "Checkout pull request" },
        merge_pr = { lhs = "<C-r>", desc = "Merge pull request" },
      },
      default_to_projects_v2 = true,
      suppress_missing_scope = {
        projects_v2 = true,
      },
    })
    -- PR
    -- Issues
  end,
  cond = in_git(),
}
