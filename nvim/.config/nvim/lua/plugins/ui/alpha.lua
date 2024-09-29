return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  enabled = true,
  init = false,
  opts = function()
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      "                                                                 ",
      " ██████╗ ███╗   ██╗███████╗    ██████╗ ██╗███████╗ ██████╗███████╗",
      "██╔═══██╗████╗  ██║██╔════╝    ██╔══██╗██║██╔════╝██╔════╝██╔════╝",
      "██║   ██║██╔██╗ ██║█████╗      ██████╔╝██║█████╗  ██║     █████╗  ",
      "██║   ██║██║╚██╗██║██╔══╝      ██╔═══╝ ██║██╔══╝  ██║     ██╔══╝  ",
      "╚██████╔╝██║ ╚████║███████╗    ██║     ██║███████╗╚██████╗███████╗",
      " ╚═════╝ ╚═╝  ╚═══╝╚══════╝    ╚═╝     ╚═╝╚══════╝ ╚═════╝╚══════╝",
      "                                                                 ",
    }
    -- dashboard.section.header.val = {
    --   "           ▄ ▄                   ",
    --   "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
    --   "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
    --   "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
    --   "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
    --   "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
    --   "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
    --   "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
    --   "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ",
    -- }

    -- dashboard.buttons.val = {
    dashboard.section.buttons.val = {
      dashboard.button("f", "󰈞  Find file", "<cmd>Telescope find_files path_display={'shorten'}<CR>"),
      dashboard.button("t", "󱄽  Find text", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("n", "  New file", "<cmd> ene <BAR> startinsert <CR>"),
      dashboard.button("d", "  Show current directory", "<cmd>Telescope file_browser<CR>"),
      dashboard.button("r", "󰄉  Recently used files", "<cmd>Telescope oldfiles<CR>"),
      dashboard.button("c", "  Configuration", "<cmd>e ~/.config/nvim/init.lua<CR>"),
      dashboard.button("l", "󰒲   Lazy", "<cmd>Lazy<CR>"),
      dashboard.button("m", "  Mason", "<cmd>Mason<CR>"),
      dashboard.button("u", "󰂖   Update plugins", "<cmd>Lazy sync <CR>"),
      dashboard.button("q", "󰅚  Quit Neovim", "<cmd>qa<CR>"),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"
    dashboard.opts.layout[1].val = 8
    return dashboard
  end,
  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      once = true,
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = "⚡ Neovim loaded "
            .. stats.loaded
            .. "/"
            .. stats.count
            .. " plugins in "
            .. ms
            .. " ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
