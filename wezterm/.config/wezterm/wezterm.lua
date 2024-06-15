-- Basing myself heavily on others' configuration files

-- Configure ssh domains

local ssh_domains = {}
local wezterm = require("wezterm")
local mux = wezterm.mux
local config = {}

config.term = "xterm-kitty"
-- declare fonts for terminal to use
-- config.color_scheme = "Catppuccin Mocha"
config.color_scheme = "catppuccin-mocha"

config.font_size = 11.5
-- config.font_size = 12
-- config.line_height = 1.3
config.font = wezterm.font_with_fallback({
  { family = "JetBrains Mono", weight = "Medium" },
  -- { family = "JetBrains Mono" },
  "Symbols Nerd Font Mono",
})
-- start on maximized
-- wezterm.on("gui-startup", function(cmd)
--   local tab, pane, window = mux.spawn_window(cmd or {})
--   window:gui_window():maximize()
-- end)

-- for host, cconfig in pairs(wezterm.enumerate_ssh_hosts()) do
--   table.insert(ssh_domains, {
--     name = host,
--     remote_address = host,
--     assume_shell = "Posix",
--     multiplexing = "None",
--   })
-- end
config.ssh_domains = ssh_domains
-- config.ssh_backend = "LibSsh"
--
-- config.set_environment_variables = {
--   TERMINFO_DIRS = "/home/rtorres/.config/wezterm",
-- }
-- config.term = "wezterm"

-- controls the window padding
config.window_frame = {
  active_titlebar_bg = "#11111B",
  inactive_titlebar_bg = "#11111B",
  button_bg = "#11111B",
}
config.window_decorations = "TITLE | RESIZE"
-- config.window_decorations = "NONE"
config.window_padding = {
  left = 1,
  right = 1,
  top = 0,
  bottom = 0,
}
config.check_for_updates = false
config.use_ime = true
config.enable_scroll_bar = false
config.enable_tab_bar = true
config.enable_wayland = true

config.hide_tab_bar_if_only_one_tab = true

config.window_background_opacity = 1.0
config.window_close_confirmation = "NeverPrompt"
config.exit_behavior = "CloseOnCleanExit"

-- specify the shell to use with wezterm
config.default_prog = { "/usr/bin/fish" }
config.scrollback_lines = 5000
config.default_workspace = "main"
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = false

config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

return config
