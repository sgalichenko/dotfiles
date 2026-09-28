# dotfiles

Managed with [dotter](https://github.com/SuperCuber/dotter). Deployed files are
**symlinks into this repo**, so editing `~/.zshrc` edits `zsh/.zshrc` directly
and the two cannot drift apart.

## Bootstrap

```sh
git clone https://github.com/sgalichenko/dotfiles.git ~/dotfiles
cd ~/dotfiles
$EDITOR .dotter/local.toml     # pick the packages for this machine
dotter deploy
```

`dotter deploy --dry-run` shows what would change without touching anything.
`--force` is needed the first time a target exists as a regular file rather
than a symlink.

## Layout

| Package   | Deploys to                                        |
|-----------|---------------------------------------------------|
| `zsh`     | `~/.zshrc`, `~/.config/starship.toml`             |
| `tmux`    | `~/.tmux.conf`, `~/.tmux/ssh_style`               |
| `wezterm` | `~/.wezterm.lua`, `~/.wezterm.minimal.lua`        |
| `ghostty` | `~/.config/ghostty/config.ghostty`                |
| `ssh`     | `~/.ssh/bin/{sshmgmt,ssh-styled}`                 |
| `nvim`    | `~/.config/nvim`                                  |
| `rofi`    | `~/.config/rofi`, `~/.config/rofi-pass/config`    |
| `vifm`    | `~/.config/vifm/{vifmrc,vifmimg,vimfm}`           |
| `yazi`    | `~/.config/yazi/{yazi,keymap,theme,package}.toml`, `init.lua`, `Nord.tmTheme` |
| `lazygit` | `~/.config/lazygit/config.yml`                    |
| `fzf`     | `~/.fzf.zsh`                                      |
| `bin`     | `~/bin/{rofi-gopass,rofi-gopass-modi,ddcswitch}`  |
| `firefox` | *not deployed* — see below                        |

`.dotter/local.toml` is gitignored: it selects which of the above apply to the
machine you're on.

## yazi plugins

The plugins live in `~/.config/yazi/plugins`, outside the repo; the tracked
`yazi/package.toml` pins them. After the first deploy, fetch them with

```sh
ya pkg install
```

`ya pkg add` and `ya pkg upgrade` write through the symlink, so the pins they
change show up in `git diff`.
