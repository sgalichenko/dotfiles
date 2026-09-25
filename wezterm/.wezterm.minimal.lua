local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = { }

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- config.default_prog = { '/usr/bin/zsh', '-c', '$(pkill ssh-agent && eval ssh-agent && ssh-add -s /usr/lib/libeToken.so)' }
config.color_scheme = 'nord'
config.font = wezterm.font 'RobotoMono Nerd Font'
config.font_size = 12.0
config.enable_tab_bar = false
config.initial_rows = 15
config.initial_cols = 70
config.hide_mouse_cursor_when_typing = false
-- config.exit_behavior = 'Hold'

config.window_frame = {
  border_left_width = '0.2cell',
  border_right_width = '0.2cell',
  border_bottom_height = '0.1cell',
  border_top_height = '0.1cell',
  border_left_color = '#ffffff',
  border_right_color = '#ffffff',
  border_bottom_color = '#ffffff',
  border_top_color = '#ffffff',
}

return config
