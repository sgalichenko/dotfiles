local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = { }

if wezterm.config_builder then
  config = wezterm.config_builder()
end

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():perform_action(wezterm.action.ToggleFullScreen, pane)
end)

config.native_macos_fullscreen_mode = true
-- -A attaches to `main` if it exists instead of creating a new session per
-- window; the trailing zsh keeps the window open if the tmux server is gone
config.default_prog = { '/usr/bin/zsh', '-lc', 'tmux new-session -A -s main || exec zsh' }
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

-- Quick-select patterns.
--
-- Written as Lua long-bracket strings (level-2 delimiters) so the regexes
-- need no backslash doubling; level 2 is required because several patterns
-- end in a `]`, which would otherwise close a plain long string early.
--
-- Two things govern this list:
--  * Passing `patterns` REPLACES wezterm's built-in set, so everything
--    wanted has to be here.
--  * The list is compiled into one alternation with leftmost-first
--    semantics, so ORDER IS PRECEDENCE. Specific patterns must precede
--    general ones, otherwise e.g. the hash pattern shatters a UUID into
--    its first and last segments instead of selecting the whole thing.
local quick_select_patterns = {
  -- URLs. Trailing punctuation is excluded so a sentence-final period or a
  -- closing paren isn't dragged into the selection.
  [==[https?://\S*[^\s.,;:!?)\]}>"']]==],

  -- Emails and user@host together. One pattern, because the old separate
  -- user@hostname regex began with \w+ and so truncated dotted local
  -- parts: first.last@host selected as just "last@host".
  [==[[\w.+-]+@[\w.-]*[\w-]]==],

  -- Hex colours, longest form first; now covers #RGBA and #RRGGBBAA too.
  [==[(?i)#(?:[0-9a-f]{8}|[0-9a-f]{6}|[0-9a-f]{4}|[0-9a-f]{3})\b]==],

  -- UUIDs and MAC addresses, before the generic hash pattern.
  [==[\b[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\b]==],
  [==[\b(?:[0-9a-f]{2}:){5}[0-9a-f]{2}\b]==],

  -- IPv4 with real 0-255 octets, keeping an optional /CIDR or :port.
  -- The old \d{1,3} form accepted 999.999.999.999 and truncated both
  -- 192.0.2.0/24 and 192.0.2.10:8443 (RFC 5737 example addresses).
  [==[\b(?:(?:25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)\.){3}(?:25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)(?:/\d{1,2})?(?::\d{1,5})?\b]==],

  -- Internal hostnames (<env><role>-<name><nn>). The trailing
  -- digit requirement keeps prose like "as-is" and "ad-hoc" out.
  [==[\b(?:s[pisd]|a[psdt]|e[mp]c?)-[\w-]*\d[\w-]*\b]==],

  -- FQDNs, restricted to plausible TLDs. An open [a-zA-Z]{2,} tail matched
  -- every filename in sight - a.pdf, file.txt, README.md - and the local
  -- part of any email.
  [==[\b(?:[\w-]+\.)+(?:com|org|net|edu|gov|io|dev|jp|local|internal|cloud|app)\b]==],

  -- Absolute, ~- and ./-relative paths of two or more segments.
  [==[(?:~|\.{1,2})?(?:/[\w.@+-]+){2,}\b]==],

  -- Hashes: git short SHA (7) through sha256 (64), and container IDs (12).
  -- Word-bounded, unlike the old bare [0-9a-f]{12}, which could only ever
  -- offer 12-char fragments of a 40-char SHA and never the SHA itself.
  -- Caveat: runs of 7+ digits also match.
  [==[\b[0-9a-f]{7,64}\b]==],
}

config.keys = {
  {
    key = 'O',
    mods = 'CTRL',
    action = wezterm.action.QuickSelectArgs {
      label = 'open url',
      patterns = {
        [==[https?://\S*[^\s.,;:!?)\]}>"']]==],
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
      patterns = quick_select_patterns,
    },
  },
}

return config
