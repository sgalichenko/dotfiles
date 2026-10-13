# dotfiles

Managed with [dotter](https://github.com/SuperCuber/dotter). Deployed files are
**symlinks into this repo**, so editing `~/.zshrc` edits `zsh/.zshrc` directly
and the two cannot drift apart.

## Bootstrap

On a fresh Ubuntu 24.04 desktop, `install.sh` does everything below unattended
(one sudo prompt at the start): tools from apt, Homebrew and cargo, every
package but `hyprland` and `wezterm`, the Firefox profile mapping, and niri as
the default session. Safe to run again.

```sh
sudo apt-get install -y git
git clone https://github.com/sgalichenko/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

By hand, or to pick other packages:

```sh
git clone https://github.com/sgalichenko/dotfiles.git ~/dotfiles
cd ~/dotfiles
$EDITOR .dotter/local.toml     # pick the packages for this machine
dotter deploy
```

`dotter deploy --dry-run` shows what would change without touching anything.
`--force` is needed the first time a target exists as a regular file rather
than a symlink.

## Packages

Each top-level directory is one package. `.dotter/global.toml` is the source of
truth for which file deploys where, with the reasons beside the odd ones.

| Package       | What it is                                                      |
|---------------|-----------------------------------------------------------------|
| `zsh`         | zsh and the starship prompt                                     |
| `tmux`        | tmux, plus helpers the ssh scripts and popups call              |
| `ssh`         | ssh helper scripts: styled sessions and a host picker           |
| `nvim`        | Neovim (lazy.nvim)                                              |
| `ghostty`     | Ghostty, including the popup terminal's config                  |
| `wezterm`     | Unused since Ghostty replaced it                                |
| `yazi`        | yazi; plugins restored with `ya pkg install` (below)            |
| `lazygit`     | lazygit                                                         |
| `bin`         | `~/bin` scripts: password menu, clipboard, popup, monitor input |
| `rofi`        | rofi, still used by `bin/gopass-menu` under GNOME               |
| `gnome`       | No files; `gnome/settings.sh` applies gsettings on each deploy  |
| `wayland`     | What `hyprland` and `niri` share, pulled in by either: bar, launcher, notifications, lock, input method, screenshots |
| `hyprland`    | Hyprland session                                                |
| `niri`        | niri session                                                    |
| `firefox`     | `userChrome.css` and `userContent.css`; targets set in `local.toml` |
| `libreoffice` | Nord theme, built and installed by `post_deploy.sh`             |
| `claude`      | Claude Code theme and tmux bell hook                            |

`.dotter/local.toml` is gitignored: it selects the packages for the machine
you're on and holds anything machine-specific.

## New machine

1. In `.dotter/local.toml`, list the packages. With `firefox`, map its two
   files to this machine's profile under `[files]`; the comment on `[firefox]`
   in `global.toml` has the lines to copy.
2. `dotter deploy`
3. Per package, as needed:
   - `hyprland` or `niri`: `sudo wayland/install.sh` for what both share, or
     `sudo hyprland/install.sh`, which runs it and adds Hyprland; for niri,
     `niri/install.sh` as yourself; then `wayland/satty/install.sh`;
     `cargo install --locked bluetui` for waybar's Bluetooth click
   - `yazi`: `ya pkg install` (see below)
   - `firefox`: set `toolkit.legacyUserProfileCustomizations.stylesheets=true`
     in `about:config`

## yazi plugins

The plugins live in `~/.config/yazi/plugins`, outside the repo; the tracked
`yazi/package.toml` pins them. After the first deploy, fetch them with

```sh
ya pkg install
```

`ya pkg add` and `ya pkg upgrade` write through the symlink, so the pins they
change show up in `git diff`.
