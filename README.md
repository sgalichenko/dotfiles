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
| `wezterm` | `~/.wezterm.lua`                                  |
| `ssh`     | `~/.ssh/bin/{sshmgmt,host2conf.awk,ssh-styled}`   |
| `nvim`    | `~/.config/nvim`                                  |
| `rofi`    | `~/.config/rofi`, `~/.config/rofi-pass/config`    |
| `vifm`    | `~/.config/vifm/{vifmrc,vifmimg,vimfm}`           |
| `lazygit` | `~/.config/lazygit/config.yml`                    |
| `fzf`     | `~/.fzf.zsh`                                      |
| `firefox` | *not deployed* — see below                        |

`.dotter/local.toml` is gitignored: it selects which of the above apply to the
machine you're on.
