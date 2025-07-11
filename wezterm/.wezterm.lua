local wezterm = require("wezterm")
local mux = wezterm.mux
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end


wezterm.on('gui-startup', function(window)
  local tab, pane, window = mux.spawn_window(cmd or {})
  local gui_window = window:gui_window();
  gui_window:perform_action(wezterm.action.ToggleFullScreen, pane)
end)

config.native_macos_fullscreen_mode = true
config.default_prog = { '/usr/bin/zsh', '-c', 'tmux' }
config.color_scheme = 'nord'
config.font = wezterm.font 'RobotoMono Nerd Font'
config.font_size = 14.0
config.enable_tab_bar = false
config.warn_about_missing_glyphs = false
config.window_background_opacity = 1
config.hide_mouse_cursor_when_typing = false

config.colors = {
	quick_select_label_bg = { Color = "#bf616a" },
	quick_select_label_fg = { Color = "#ffffff" },
	quick_select_match_bg = { Color = "#ebcb8b" },
	quick_select_match_fg = { Color = "#2e3440" },
}

config.quick_select_patterns = {
	"\\w+\\@\\S+-?\\w+",
}

config.keys = {
	{
		key = "O",
		mods = "CTRL",
		action = wezterm.action.QuickSelectArgs({
			label = "open url",
			patterns = {
				"https?://\\S+",
			},
			action = wezterm.action_callback(function(window, pane)
				local url = window:get_selection_text_for_pane(pane)
				wezterm.log_info("opening: " .. url)
				wezterm.open_with(url)
			end),
		}),
	},
	{
		key = "C",
		mods = "CTRL",
		action = wezterm.action.QuickSelectArgs({
			patterns = {
				-- user@hostname: stricter match, avoid trailing punctuation and capture valid hostnames
				[[\b[\w.-]+@(?:[\w-]+\.)+[\w-]+\b]],

				-- Unix-style absolute and relative file paths, including tilde (~) and dot (.)
				[[(?:(?:~|\.{1,2})?/)?(?:[\w.-]+/)+[\w.-]+]],

				-- IPv4: accurate match for 0.0.0.0–255.255.255.255
				[[\b(?:(?:25[0-5]|2[0-4]\d|1?\d{1,2})\.){3}(?:25[0-5]|2[0-4]\d|1?\d{1,2})\b]],

				-- Hex color: 3 or 6-digit, with optional # prefix
				[[(?i)\B#(?:[0-9a-f]{6}|[0-9a-f]{3})\b]],

				-- Container IDs: 12–64 lowercase hex characters
				[[\b[a-f0-9]{12,64}\b]],
				-- user@hostname
				--"\\w+\\@\\S+-?\\w+",
				-- paths
				--"(?:[\\w\\-\\.]+|~)?(?:/[\\w\\-\\.]+){2,}\\b",
				-- IPv4
				--"\\b\\d{1,3}(?:\\.\\d{1,3}){3}\\b",
				-- HEX colors
				--"(?i)#(?:[0-9a-f]{3}|[0-9a-f]{6})\\b",
			},
		}),
	},
}

return config
