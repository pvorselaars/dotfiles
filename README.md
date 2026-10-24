# dotfiles

| In the repo | Goes to | How |
|---|---|---|
| `config/*` | `~/.config/*` | `stow` |
| `.profile`, `.ideavimrc`, `.clang-format` | `~/` | symlinks |
| `etc/greetd` | `/etc/greetd` | `etc/greetd/install` (needs sudo) |
| `etc/snapper` | snapshots of `/home` | `etc/snapper/install` (needs sudo, `--dry-run` shows the steps) |

## Install

```
cd ~/.config && stow ~/Projects/dotfiles/config
```

`stow` is in `~/Projects/scripts`. It skips hidden files, so the three files in the root are symlinked into `~/` by
hand. The scripts the config calls (`statusbar`, `lock-screen`, ...) are in that repo and linked into `~/.local/bin`.

`.clang-format` is the C and C++ style for Neovim: tabs of 8, 120 columns, close to `indent -linux`.

## Rider

Rider uses the Neovim colours. Run both with Rider closed, it writes its settings back when it closes:

```
node ~/Projects/dotfiles/rider/make-onedark-scheme.js --install
~/Projects/dotfiles/rider/install-one-dark-theme
```

The first builds the editor scheme from Neovim's colours. Run it again after a change in
`config/nvim/lua/plugins/colors.lua`. Without `--install` it only writes the file and checks it. The second installs
the "One Dark Theme" plugin (Islands variant) for menus, tabs and tool windows. It is pinned to one version and
checksum. Its colours are close to Neovim's, not the same.

To go back, delete `options/laf.xml` and the folder `one-dark-theme` in `~/.local/share/JetBrains/Rider*`, and copy
`options/colors.scheme.xml.before-onedark` over `options/colors.scheme.xml`.

## Not in this repo

- `~/.bashrc` is local. Secrets are in the keyring and loaded with `secret-tool`. To add one:
  `printf %s "value" | secret-tool store --label="bashrc NAME" service bashrc name NAME`, then add `NAME` to the loop
  in `.bashrc`.
- `~/.config/JetBrains/*/*.vmoptions`: Toolbox puts tokens in them.
- `config/sway/wallpaper.conf` is generated.
