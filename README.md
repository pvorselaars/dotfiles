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
Its `*` glob skips hidden files, so the three dotfiles in the repo root are linked by hand (`.clang-format` is the C++ style for clangd: tabs of 8 like the C setup, see its first lines):

```
ln -sfn ~/Projects/dotfiles/.profile ~/.profile
ln -sfn ~/Projects/dotfiles/.ideavimrc ~/.ideavimrc
ln -sfn ~/Projects/dotfiles/.clang-format ~/.clang-format
```

Scripts used by the config (`statusbar`, `lock-screen`, `scale-step`, ...) live in `~/Projects/scripts` and are linked into `~/.local/bin`.

## Rider colours

Rider's editor uses the same colours as Neovim (and as foot): the scheme "One Dark (Neovim)", built by `rider/make-onedark-scheme.js`.
It takes the colour scheme that Rider ships with and gives every role (keywords, strings, types, parameters, ...) the colour that
Neovim shows for it, read from a running Neovim, so a change in `config/nvim/lua/plugins/colors.lua` carries over when you run it again.
Only the editor colours change.

```
node ~/Projects/dotfiles/rider/make-onedark-scheme.js --install     # with Rider closed
```

Without `--install` it only writes the file and checks it. It refuses to install while Rider is open, because Rider writes its
settings back when it closes. The generated scheme is not kept in this repo (it is derived from a scheme that JetBrains ships), so run
the script again after a Rider update or a colour change. To go back, copy `options/colors.scheme.xml.before-onedark` over
`options/colors.scheme.xml` in Rider's settings folder, or pick another scheme under Settings, Editor, Color Scheme.

The **window colours** (menus, tabs, tool windows) come from the plugin "One Dark Theme" by Mark Skelton, in its Islands variant,
installed by `rider/install-one-dark-theme` (also with Rider closed, and after the scheme above):

```
~/Projects/dotfiles/rider/install-one-dark-theme
```

The plugin is pinned to one version and checksum, and the script refuses it if it holds anything but theme files (no code). It
makes the theme "One Dark Islands" the active one in `options/laf.xml` and leaves the editor scheme alone. The plugin's colours are
close to, not the same as, Neovim's: its window background is `#202329` where Neovim and foot have `#1f2329`. No JetBrains plugin has
the exact palette of onedark.nvim "darker" (they use the classic Atom One Dark colours), which is why the editor scheme is generated.
To go back, delete `options/laf.xml` and the folder `one-dark-theme` in Rider's plugin folder (`~/.local/share/JetBrains/Rider*`).

## Not in this repo

- `~/.bashrc`: it is a local file. Secrets are not kept in it: they live in the keyring and are loaded with `secret-tool`.
  Add one with `printf %s "value" | secret-tool store --label="bashrc NAME" service bashrc name NAME`, then add `NAME` to the loop in `.bashrc`.
- `~/.config/JetBrains/*/*.vmoptions`: Toolbox puts tokens in them. Only `.ideavimrc` is kept here.
- `config/sway/wallpaper.conf` is generated (see `.gitignore`).
