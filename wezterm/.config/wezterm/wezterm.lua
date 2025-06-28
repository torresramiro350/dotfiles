-- Basing myself heavily on others' configuration files
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local appearance = require("appearance")

if appearance.is_dark() then
	config.color_scheme = "Catppuccin Mocha"
else
	config.color_scheme = "Catppuccin Latte"
end

config.window_background_opacity = 1
config.font_size = 10
config.line_height = 1.15
-- config.font = wezterm.font("JetBrains Mono")
-- config.font = wezterm.font("Maple Mono NF", { weight = "Medium", italic = false })
config.font = wezterm.font("Maple Mono", { weight = "Medium", italic = false })
-- config.font = wezterm.font("JetBrains Mono", { weight = "DemiBold", italic = false })
-- config.font = wezterm.font("JetBrainsMono NF", { weight = "DemiBold", italic = false })

config.window_decorations = "TITLE | RESIZE"
-- config.window_decorations = "RESIZE|TITLE|INTEGRATED_BUTTONS"
config.window_frame = {
	font = wezterm.font({ family = "Adwaitas Mono", weight = "Bold", italic = false }),
	font_size = 11,
}

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.check_for_updates = false
config.use_ime = true
config.enable_scroll_bar = false
config.enable_tab_bar = false
config.enable_wayland = true

config.hide_tab_bar_if_only_one_tab = true

config.window_background_opacity = 1.0
config.window_close_confirmation = "NeverPrompt"
config.exit_behavior = "CloseOnCleanExit"

-- specify the shell to use with wezterm
config.scrollback_lines = 5000
config.default_workspace = "main"
config.use_fancy_tab_bar = true
config.status_update_interval = 1000
config.tab_bar_at_bottom = false

config.keys = {
	{ key = "A", mods = "CTRL|SHIFT", action = wezterm.action.QuickSelect },
}

config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

return config
