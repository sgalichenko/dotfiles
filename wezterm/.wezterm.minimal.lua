local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = { }

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- config.default_prog = { '/usr/bin/zsh', '-c', '$(pkill ssh-agent && eval ssh-agent && ssh-add -s /usr/lib/libeToken.so)' }
config.color_scheme = 'nord'
config.font = wezterm.font 'RobotoMono Nerd Font'
config.font_size = 11.0
config.enable_tab_bar = false
config.initial_rows = 15
config.initial_cols = 70
config.hide_mouse_cursor_when_typing = false
-- Only popups use this config (bluetui, nmtui, gopass), so closing one,
-- e.g. a second click on its bar icon, should not stop to ask first
config.window_close_confirmation = 'NeverPrompt'
-- nmtui (the network popup) in flat Nord like bluetui: newt's default palette
-- turns into pink and red blocks under the nord scheme. Names are the
-- terminal's ANSI colours; default is the window background.
config.set_environment_variables = {
  NEWT_COLORS = table.concat({
    'root=white,default', 'window=white,default', 'border=cyan,default',
    'shadow=default,default', 'title=cyan,default', 'textbox=white,default',
    'label=white,default', 'helpline=gray,default', 'roottext=gray,default',
    'listbox=white,default', 'actlistbox=white,default',
    'sellistbox=cyan,default', 'actsellistbox=black,cyan',
    'button=white,black', 'actbutton=black,cyan', 'compactbutton=white,default',
    'checkbox=white,default', 'actcheckbox=black,cyan',
    'entry=white,black', 'disentry=gray,default',
    'emptyscale=,black', 'fullscale=,cyan',
  }, ';'),
}
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
