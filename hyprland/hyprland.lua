-- Minimal Nord Hyprland. niri is the default session (niri/install.sh sets it).
-- niri/config.kdl is the same setup for niri; scripts both use live in wayland/scripts/.
-- Installed by hyprland/install.sh; `hyprctl reload` picks up edits (it also
-- reloads on save). `Hyprland --verify-config` checks this file.
-- API stubs for lua-language-server: /usr/share/hypr/stubs/hl.meta.lua

-- ---------- Palette (Nord) ----------
local bg    = "rgb(2f343f)"
local nord1 = "rgb(3b4252)"
local frost = "rgb(81a1c1)" -- nord9: a step dimmer than nord8 (88c0d0)
-- nord13 (ebcb8b) with 40% nord0 (2e3440) mixed in, so urgent borders glow less
local yellow = "rgb(9f8f6d)"

-- ---------- Monitors ----------
-- The 4K Dell sits left of the laptop at scale 1.5 (2560x1440 logical), so the
-- laptop starts at x=2560 and drops 240 to line up their bottom edges.
-- The 1080p Dell sits on top of the laptop instead: same width, so it starts
-- at the laptop's x and ends where the laptop begins (240 - 1080 = -840).
-- Anything else is auto-placed at its preferred mode and scale 1.
local dell = "desc:Dell Inc. DELL U2723QX 9TM1ZN3"
local dell_top = "desc:Dell Inc. DELL U2417H FFVVR73V167L"
hl.monitor({ output = dell,     mode = "preferred", position = "0x0",       scale = 1.5 })
hl.monitor({ output = dell_top, mode = "preferred", position = "2560x-840", scale = 1 })
hl.monitor({ output = "eDP-1",  mode = "preferred", position = "2560x240",  scale = 1 })
hl.monitor({ output = "",      mode = "preferred", position = "auto",   scale = 1 })

-- ---------- Environment ----------
hl.env("XCURSOR_THEME", "Yaru")
hl.env("XCURSOR_SIZE", "24")
-- GNOME's SSH agent, which its session normally exports: gcr-ssh-agent,
-- socket-activated by systemd (gnome-keyring's old keyring/ssh is gone in
-- 24.04). A literal path: env values aren't shell-expanded, so this assumes
-- uid 1000.
hl.env("SSH_AUTH_SOCK", "/run/user/1000/gcr/ssh")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("MOZ_ENABLE_WAYLAND", "1")
-- fcitx5 for Japanese (Mozc), not GNOME's IBus: IBus can't speak Hyprland's
-- input-method-v2, so Wayland apps never saw it. GTK_IM_MODULE stays unset so
-- GTK uses Wayland's text-input; XWayland apps go through XIM.
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")

-- ---------- Autostart ----------
hl.on("hyprland.start", function()
    -- Portals and other systemd user services need to find this session. The
    -- portal outlives a logout, so one left from a niri session would keep
    -- niri-portals.conf; restarting it makes it read hyprland-portals.conf.
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE SSH_AUTH_SOCK && systemctl --user restart xdg-desktop-portal")
    hl.exec_cmd("~/.config/wayland/wm bar")
    hl.exec_cmd("~/.config/wayland/hotplug.sh")
    hl.exec_cmd("mako")
    -- Notes which notifications timed out unseen, for Super+N's missed dot
    hl.exec_cmd("~/.config/wayland/notify-watch.sh")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("fcitx5 -d --replace")
    -- Clipboard history for Super+V: text and images as they're copied
    hl.exec_cmd("wl-paste --type text --watch ~/.config/wayland/cliphist-store.sh")
    hl.exec_cmd("wl-paste --type image --watch ~/.config/wayland/cliphist-store.sh")
    -- Night light (see hyprsunset.conf); USB drives mount on plug-in, with a notification
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("udiskie --automount --notify")
end)

-- ---------- Look ----------
hl.config({
    general = {
        gaps_in     = 3,
        gaps_out    = 6,
        border_size = 2,
        col = {
            active_border   = frost,
            inactive_border = nord1,
        },
        layout = "dwindle",
    },

    decoration = {
        rounding = 0,
        shadow   = { enabled = false },
        blur     = { enabled = false },
    },

    -- Off: windows and workspaces appear instantly
    animations = { enabled = false },

    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        background_color         = bg,
        force_default_wallpaper  = 0,
        -- Focusing another window on a maximized workspace (Alt+Tab, a click, a
        -- new window) maximizes that one instead, so maximized windows act as a stack
        on_focus_under_fullscreen = 1,
        -- If hyprlock dies, the screen stays locked; this lets a fresh hyprlock
        -- take over (from a TTY: hyprctl --instance 0 dispatch 'hl.dsp.exec_cmd("hyprlock")')
        allow_session_lock_restore = true,
    },

    dwindle = { preserve_split = true },

    -- ---------- Input ----------
    -- Matches GNOME here: US layout, natural scrolling and tap-to-click on the
    -- touchpad, 500 ms repeat delay at 30 ms intervals (~33/s).
    input = {
        kb_layout    = "us",
        repeat_delay = 500,
        repeat_rate  = 33,
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
            tap_to_click   = true,
        },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- ---------- Workspaces ----------
-- herbstluftwm's five fixed tags: always there, so Super+Ctrl+Left/Right cycle
-- through all five and the bar shows them even when empty. Each monitor starts
-- on one of them, so plugging in the Dell does not spawn a sixth.
hl.workspace_rule({ workspace = "1", monitor = dell,    default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1", default = true, persistent = true })
for i = 3, 5 do
    hl.workspace_rule({ workspace = tostring(i), persistent = true })
end

-- ---------- Keys ----------
-- Follows the old herbstluftwm autostart (git show e29c1cb^:herbstluftwm/autostart).
-- Changed from it: focus is Super+arrows, not Ctrl+arrows, which tmux uses
-- for panes, so workspace next/previous moves to Super+Ctrl+Left/Right;
-- resizing moves from Super+Ctrl to Super+Alt to make room.
-- Ctrl+Space is kept for the launcher, so it never reaches nvim's completion.
local mod   = "SUPER"
local term  = "ghostty"
local shots = "~/Pictures/screenshots"
local exec  = hl.dsp.exec_cmd
local hypr  = "~/.config/hypr/"
local wl    = "~/.config/wayland/"
local bind  = hl.bind

bind(mod .. " + SHIFT + Q", hl.dsp.exit())
bind(mod .. " + SHIFT + R", exec(hypr .. "reload.sh"))
bind(mod .. " + SHIFT + C", hl.dsp.window.close())

-- Apps
-- A fresh tmux session per window, killed when its window closes so they don't pile up;
-- named `main` if that name is free, as Ghostty's own command does
bind(mod .. " + Return", exec(term .. " -e /usr/bin/zsh -lc 'tmux new-session $(tmux has-session -t main 2>/dev/null || echo -s main) \\; set destroy-unattached on || exec zsh'"))
bind("CTRL + Space", exec(wl .. "launcher.sh"))
-- Yazi in its own tmux session, gone once yazi quits or the window closes
bind(mod .. " + Y", exec(term .. " -e /usr/bin/zsh -lc 'tmux new-session yazi \\; set destroy-unattached on || exec yazi'"))
bind(mod .. " + Escape", exec(wl .. "sysmenu.sh"))
bind(mod .. " + N", exec(wl .. "notifications.sh"))
bind(mod .. " + L", exec("loginctl lock-session"))
bind("CTRL + ALT + P", exec("~/bin/gopass-menu"))
bind(mod .. " + M", exec("~/bin/ddcswitch"))
-- Copy the primary selection to the clipboard
bind("CTRL + 0", exec("wl-paste -p -n | wl-copy"))
-- Print and Super+Ctrl+P: drag out a region (slurp, which spans both monitors)
-- and annotate it in Satty; Enter copies it, Ctrl+S saves it to shots (see
-- wayland/satty/config.toml). Shift+Print saves the whole screen and copies it too.
local snip = "g=$(slurp -d -b 2e344080 -c 81a1c1) && grim -g \"$g\" - | ~/.cargo/bin/satty --filename -"
bind("Print", exec(snip))
bind("SHIFT + Print", exec("mkdir -p " .. shots .. " && f=" .. shots .. "/$(date +%Y%m%d-%H%M%S).png && grim \"$f\" && wl-copy < \"$f\""))
bind(mod .. " + CTRL + P", exec(snip))
-- Clipboard history: pick an entry and it's copied again
bind(mod .. " + V", exec(wl .. "clipboard.sh"))

-- Focus
bind(mod .. " + Left",  hl.dsp.focus({ direction = "left" }))
bind(mod .. " + Down",  hl.dsp.focus({ direction = "down" }))
bind(mod .. " + Up",    hl.dsp.focus({ direction = "up" }))
bind(mod .. " + Right", hl.dsp.focus({ direction = "right" }))
-- Alt+Tab cycles windows on the workspace; Super+Tab jumps between monitors,
-- i.e. between the workspaces on screen
bind("ALT + Tab",         hl.dsp.window.cycle_next())
bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))
bind(mod .. " + Tab",         hl.dsp.focus({ monitor = "+1" }))
bind(mod .. " + SHIFT + Tab", hl.dsp.focus({ monitor = "-1" }))
bind(mod .. " + C",         hl.dsp.window.cycle_next())
bind(mod .. " + BackSpace", hl.dsp.focus({ monitor = "+1" }))
bind(mod .. " + I",         hl.dsp.focus({ urgent_or_last = true }))

-- Move windows
-- move.sh sends a maximized/fullscreen window to the next monitor instead
for _, k in ipairs({
    { "Left", "l" }, { "Down", "d" }, { "Up", "u" }, { "Right", "r" },
    { "H", "l" },    { "J", "d" },    { "K", "u" },  { "L", "r" },
}) do
    bind(mod .. " + SHIFT + " .. k[1], exec(hypr .. "move.sh " .. k[2]))
end

-- Splitting: herbstluftwm's split bottom/right become dwindle's preselect,
-- which places the next window there. Super+Space cycled the frame layout;
-- here it flips the split.
bind(mod .. " + U",     hl.dsp.layout("preselect d"))
bind(mod .. " + O",     hl.dsp.layout("preselect r"))
bind(mod .. " + Space", hl.dsp.layout("togglesplit"))

-- Input method: Alt+Shift is fcitx5's own (see wayland/fcitx5/config), not bound here

-- Resize, repeating while held
for _, k in ipairs({
    { "Left", -20, 0 }, { "Right", 20, 0 }, { "Up", 0, -20 }, { "Down", 0, 20 },
    { "H", -20, 0 },    { "L", 20, 0 },     { "K", 0, -20 },  { "J", 0, 20 },
}) do
    bind(mod .. " + ALT + " .. k[1], hl.dsp.window.resize({ x = k[2], y = k[3], relative = true }), { repeating = true })
end

-- Layouting
bind(mod .. " + S",         hl.dsp.window.float())
bind(mod .. " + SHIFT + S", hl.dsp.window.float())
-- Super+Shift+F maximizes: fills the monitor but keeps the bar and gaps
bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
bind(mod .. " + F",         hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bind(mod .. " + P",         hl.dsp.window.pseudo())

-- Workspaces: Super+N goes there, Super+Shift+N sends the window and stays
for i = 1, 5 do
    bind(mod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
end
-- Super+arrows move focus (see Focus), so next/previous sits on Ctrl
bind(mod .. " + CTRL + Right", hl.dsp.focus({ workspace = "e+1" }))
bind(mod .. " + CTRL + Left",  hl.dsp.focus({ workspace = "e-1" }))
-- herbstluftwm's cycletag dragged Picture-in-Picture along; here it's pinned
-- (see Rules), so these are plain next/previous
bind(mod .. " + Period", hl.dsp.focus({ workspace = "e+1" }))
bind(mod .. " + Comma",  hl.dsp.focus({ workspace = "e-1" }))

-- Mouse: Super+drag moves, Super+right-drag resizes
bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys work on the lock screen too (locked) and repeat when held (repeating).
-- Bare F1-F3 double as volume keys; F6/F7 stay free since yazi uses F5/F6.
local held   = { locked = true, repeating = true }
local locked = { locked = true }
bind("XF86AudioRaiseVolume",  exec(wl .. "volume.sh up"), held)
bind("XF86AudioLowerVolume",  exec(wl .. "volume.sh down"), held)
bind("XF86AudioMute",         exec(wl .. "volume.sh mute"), locked)
bind("F1",                    exec(wl .. "volume.sh mute"), locked)
bind("F2",                    exec(wl .. "volume.sh down"), held)
bind("F3",                    exec(wl .. "volume.sh up"), held)
bind("XF86AudioMicMute",      exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), locked)
bind("XF86MonBrightnessUp",   exec(wl .. "brightness.sh up"), held)
bind("XF86MonBrightnessDown", exec(wl .. "brightness.sh down"), held)
bind("XF86AudioPlay",         exec("playerctl play-pause"), locked)
bind("XF86AudioNext",         exec("playerctl next"), locked)
bind("XF86AudioPrev",         exec("playerctl previous"), locked)

-- ---------- Rules ----------
-- From herbstluftwm's rules, for apps still installed here
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, float = true, pin = true })
-- Satty's annotation window over whatever was captured
hl.window_rule({ match = { class = "^(com.gabm.satty)$" }, float = true, center = true })
hl.window_rule({ match = { class = "^(ghostty.floatingTerminal|qrcode|swayimg)$" }, float = true, center = true })
hl.window_rule({ match = { class = "^(blueman-manager)$" }, float = true, center = true })
-- The clock's calendar: a popup dropped under the clock, still wide enough for the month view
hl.window_rule({ match = { class = "^(org.gnome.Calendar)$" }, float = true, size = "960 640", move = "((monitor_w-960)/2) 40" })
-- Opened by Calendar's Online Accounts (see wayland/dbus/org.gnome.Settings.service)
hl.window_rule({ match = { class = "^(org.gnome.Settings)$" }, float = true, center = true, size = "(monitor_w*0.5) (monitor_h*0.7)" })
-- waybar's Bluetooth and network clicks: small popups tucked under the bar's right end
hl.window_rule({ match = { class = "^(ghostty.bluetuiPopup)$" }, float = true, size = "640 400", move = "(monitor_w-646) 40" })
hl.window_rule({ match = { class = "^(ghostty.nmtuiPopup)$" },   float = true, size = "640 400", move = "(monitor_w-646) 40" })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, float = true, size = "640 480", move = "(monitor_w-646) 40" })
hl.window_rule({ match = { class = "^(firefox)$" }, workspace = "1" })

-- A window that asks for attention (a terminal bell rang in it, see Ghostty's
-- bell-features) gets a yellow border until it's focused. Urgency has no border
-- colour of its own, so it's a tag that a rule colours. Both colours, since an
-- urgent window is never the focused one.
hl.window_rule({ name = "urgent-border", match = { tag = "urgent" }, border_color = yellow .. " " .. yellow })
local function tag_urgent(w, tag)
    -- Focusing an empty monitor (Super+Tab) fires window.active with no address
    if w and w.address then hl.dispatch(hl.dsp.window.tag({ tag = tag, window = "address:" .. w.address })) end
end
hl.on("window.urgent", function(w) tag_urgent(w, "+urgent") end)
hl.on("window.active", function(w) tag_urgent(w, "-urgent") end)
