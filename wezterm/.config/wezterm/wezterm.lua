-- Basing myself heavily on others' configuration files
local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()

function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

-- config.term = "xterm-kitty"
-- config.term = "wezterm"
-- declare fonts for terminal to use
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

config.font_size = 10.0
config.line_height = 1.2
config.font = wezterm.font({ family = "JetBrains Mono", weight = "Medium" })
-- config.font = wezterm.font({ family = "JetBrainsMono Nerd Font", weight = "Medium" })

config.ssh_domains = ssh_domains

-- controls the window padding
-- config.window_frame = {
--   font = wezterm.font({ family = "Inter", weight = "Medium" }),
--   font_size = 11,
--   active_titlebar_bg = "#11111B",
--   inactive_titlebar_bg = "#11111B",
--   button_bg = "#11111B",
-- }
config.window_decorations = "TITLE | RESIZE"
-- config.window_decorations = "RESIZE"
config.window_padding = {
  left = 3,
  right = 3,
  top = 0,   -- wayland
  bottom = 0, -- wayland
}
config.check_for_updates = false
config.use_ime = true
config.enable_scroll_bar = false
config.enable_tab_bar = false
config.enable_wayland = false

config.hide_tab_bar_if_only_one_tab = true

config.window_background_opacity = 1.0
config.window_close_confirmation = "NeverPrompt"
config.exit_behavior = "CloseOnCleanExit"

-- specify the shell to use with wezterm
config.default_prog = { "/usr/bin/fish" }
-- config.default_prog = {"/usr/bin/nu"}
config.scrollback_lines = 5000
config.default_workspace = "main"
config.use_fancy_tab_bar = true
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
