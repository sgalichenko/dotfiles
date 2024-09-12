local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = { }

if wezterm.config_builder then
  config = wezterm.config_builder()
end

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)

config.default_prog = { '/usr/bin/zsh', '-c', 'tmux' }
config.color_scheme = 'nord'
config.font = wezterm.font 'RobotoMono Nerd Font'
config.font_size = 14.0
config.enable_tab_bar = false
config.warn_about_missing_glyphs = false
config.window_background_opacity = 1
config.hide_mouse_cursor_when_typing = false

config.colors = {
  quick_select_label_bg = { Color = '#bf616a' },
  quick_select_label_fg = { Color = '#ffffff' },
  quick_select_match_bg = { Color = '#ebcb8b' },
  quick_select_match_fg = { Color = '#2e3440' },
}

config.quick_select_patterns = {
    '\\w+\\@\\S+-?\\w+',
}

config.keys = {
  {
    key = 'O',
    mods = 'CTRL',
    action = wezterm.action.QuickSelectArgs {
      label = 'open url',
      patterns = {
        'https?://\\S+',
      },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.log_info('opening: ' .. url)
        wezterm.open_with(url)
      end),
    },
  },
  {
    key = 'C',
    mods = 'CTRL',
    action = wezterm.action.QuickSelectArgs {
      patterns = {
        -- user@hostname
        '\\w+\\@\\S+-?\\w+',
        -- paths
        '(?:[\\w\\-\\.]+|~)?(?:/[\\w\\-\\.]+){2,}\\b',
        -- IPv4
        '\\b\\d{1,3}(?:\\.\\d{1,3}){3}\\b',
        -- HEX colors
        '(?i)#(?:[0-9a-f]{3}|[0-9a-f]{6})\\b',
      },
    },
  },
}

return config
