# dotfiles

| In the repo | Goes to | How |
|---|---|---|
| `config/*` | `~/.config/*` | `stow` (from `~/Projects/scripts`) |
| `.profile`, `.ideavimrc` | `~/` | symlinks, see below |
| `etc/greetd` | `/etc/greetd` | `etc/greetd/install` (copies, needs sudo) |
| `etc/snapper` | snapshots of `/home` | `etc/snapper/install` (needs sudo; `--dry-run` shows the steps) |

## Install

```
cd ~/.config && stow ~/Projects/dotfiles/config
```

`stow` links every item of the given folder into the current folder (`ln -sfn`), so it is safe to run again.
Its `*` glob skips hidden files, so the two dotfiles in the repo root are linked by hand:

```
ln -sfn ~/Projects/dotfiles/.profile ~/.profile
ln -sfn ~/Projects/dotfiles/.ideavimrc ~/.ideavimrc
```

Scripts used by the config (`statusbar`, `lock-screen`, `scale-step`, ...) live in `~/Projects/scripts` and are linked into `~/.local/bin`.

## Not in this repo

- `~/.bashrc`: it is a local file. Secrets are not kept in it: they live in the keyring and are loaded with `secret-tool`.
  Add one with `printf %s "value" | secret-tool store --label="bashrc NAME" service bashrc name NAME`, then add `NAME` to the loop in `.bashrc`.
- `~/.config/JetBrains/*/*.vmoptions`: Toolbox puts tokens in them. Only `.ideavimrc` is kept here.
- `config/sway/wallpaper.conf` is generated (see `.gitignore`).
