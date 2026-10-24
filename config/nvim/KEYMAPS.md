# Neovim keymaps

Leader is `Space`, local leader is `,`.

- Press `Space` and wait: which-key shows the menu for that prefix.
- `Space ?` lists the keys that exist in the current buffer.
- `Space f k` searches every keymap and command by name.

Keys marked *built in* come with Neovim itself, not from this config.
Run `./check-keymaps.sh` to verify this file against the real mappings.

Modes: `n` normal, `x` visual, `i` insert, `t` terminal, `o` operator-pending.

## Editing

<!-- check: global -->

| Key | Mode | What it does |
|---|---|---|
| `J` | x | Move selected lines down |
| `K` | x | Move selected lines up |
| `<` | x | Indent left, keep the selection |
| `>` | x | Indent right, keep the selection |
| `<leader>x` | n x | Delete without yanking |
| `<leader>p` | x | Paste over the selection without losing your yank |
| `<leader>y` | n x | Yank to the system clipboard |
| `<leader>Y` | n | Yank the line to the system clipboard |
| `<Esc>` | n | Clear the search highlight |
| `gc` | n x | Toggle comment (*built in*) |
| `gcc` | n | Toggle comment on the line (*built in*) |
| `an` | x | Grow the selection by one syntax node (*built in*) |
| `in` | x | Shrink the selection by one syntax node (*built in*) |
| `[<Space>` | n | Add a blank line above (*built in*) |
| `]<Space>` | n | Add a blank line below (*built in*) |
| `gx` | n | Open the URL or file under the cursor (*built in*) |

## Moving around

<!-- check: global -->

| Key | Mode | What it does |
|---|---|---|
| `<C-d>` | n | Half page down, cursor stays centred |
| `<C-u>` | n | Half page up, cursor stays centred |
| `n` | n | Next search match, centred |
| `N` | n | Previous search match, centred |
| `<A-Left>` | n | Back in the jump list, e.g. after going to a definition (Rider: Alt+Left) |
| `<A-Right>` | n | Forward in the jump list (Rider: Alt+Right) |
| `]b` | n | Next buffer (*built in*) |
| `[b` | n | Previous buffer (*built in*) |
| `]q` | n | Next quickfix item (*built in*) |
| `[q` | n | Previous quickfix item (*built in*) |
| `]d` | n | Next diagnostic (*built in*) |
| `[d` | n | Previous diagnostic (*built in*) |
| `<C-w>d` | n | Show the diagnostic under the cursor (*built in*) |

## Windows

<!-- check: global -->

| Key | Mode | What it does |
|---|---|---|
| `<C-h>` | n | Go to the window on the left |
| `<C-j>` | n | Go to the window below |
| `<C-k>` | n | Go to the window above |
| `<C-l>` | n | Go to the window on the right |
| `<C-Up>` | n | Taller |
| `<C-Down>` | n | Shorter |
| `<C-Left>` | n | Narrower |
| `<C-Right>` | n | Wider |
| `<leader>wv` | n | Split vertically |
| `<leader>ws` | n | Split horizontally |
| `<leader>wo` | n | Close all other windows |
| `<leader>wc` | n | Close this window |
| `<leader>w=` | n | Make all windows equal size |

## Buffers and files

<!-- check: global -->

| Key | Mode | What it does |
|---|---|---|
| `<leader>bb` | n | Switch to the previous buffer |
| `<leader>bd` | n | Delete the buffer |
| `<leader>bD` | n | Delete the buffer and discard changes |
| `<leader>e` | n | File explorer in this file's folder |

## Find (telescope)

<!-- check: global -->

| Key | Mode | What it does |
|---|---|---|
| `<leader>ff` | n | Files |
| `<leader>fg` | n | Grep in the project |
| `<leader>fw` | n x | Grep for the word under the cursor or the selection |
| `<leader>fb` | n | Open buffers |
| `<leader>fr` | n | Recent files |
| `<leader>fR` | n | Resume the last search |
| `<leader>fs` | n | Symbols in this file |
| `<leader>fS` | n | Symbols in the project |
| `<leader>fd` | n | Diagnostics in this file |
| `<leader>fD` | n | Diagnostics in the project |
| `<leader>fh` | n | Help |
| `<leader>fk` | n | Keymaps |
| `<leader>fc` | n | Commands |
| `<leader>fB` | n i | Pick a citation from the bibliography and insert `\cite{key}` |

## Search and replace

<!-- check: global -->

| Key | Mode | What it does |
|---|---|---|
| `<leader>sr` | n | Replace the word under the cursor in this file |

## Code (needs a language server)

<!-- check: lsp -->

| Key | Mode | What it does |
|---|---|---|
| `gd` | n | Go to definition |
| `gD` | n | Go to declaration |
| `K` | n | Hover documentation (*built in*) |
| `grr` | n | References (*built in*) |
| `gri` | n | Implementations (*built in*) |
| `grt` | n | Type definition (*built in*) |
| `gO` | n | Symbols in this file (*built in*) |
| `grn` | n | Rename (*built in*) |
| `gra` | n x | Code action (*built in*) |
| `<C-s>` | i | Signature help (*built in*) |
| `<leader>ca` | n | Code action |
| `<leader>cr` | n | Rename symbol |
| `<leader>cd` | n | Diagnostics for this line |
| `<leader>cl` | n | Run the code lens |
| `<leader>cR` | n | Refactor this: the refactoring code actions (Rider: Ctrl+Shift+R) |
| `<F12>` | n | Go to definition (Rider: F12) |
| `<C-F12>` | n | Go to implementation, in a picker if there are several (Rider: Ctrl+F12) |
| `<A-F12>` | n | Peek the implementations, never jumps (Rider: Alt+F12) |
| `<S-F12>` | n | Show the usages in a picker (Rider: Shift+F12) |
| `<A-S-F12>` | n | Find the usages, in the quickfix list (Rider: Shift+Alt+F12) |
| `<F2>` | n | Rename (Rider: F2) |
| `<C-.>` | n x | Quick fix, code action (Rider: Ctrl+.) |
| `<C-S-Space>` | n i | Parameter info, signature help (Rider: Ctrl+Shift+Space) |
| `<A-F>` | n x | Format (Rider: Shift+Alt+F) |
| `<A-O>` | n | Optimize imports (Rider: Shift+Alt+O) |
| `<C-S-m>` | n | Problems in the whole project (Rider: Ctrl+Shift+M) |
| `<A-F8>` | n | Next problem, shown in a popup (Rider: Alt+F8) |
| `<S-F8>` | n | Previous problem (Rider: Shift+F8) |
| `<A-H>` | n | Call hierarchy: who calls this (Rider: Shift+Alt+H) |

## Coming from Rider

Rider here uses the keymap "VSCode". Two sets of keys work **the same in both editors**:

- The **`g` and `<leader>` keys** (`gd`, `grr`, `<leader>cr`, `<leader>ca`, ...). Rider gets them from IdeaVim,
  through `~/.ideavimrc`, which mirrors this file.
- **Rider's own keys** (F12, F2, Ctrl+., Alt+F8, ...). These work in Rider by themselves, and Neovim has the same keys now.

So the table below lists, for each action, Rider's own key, the Vim-style key that works in both, and what Neovim
adds. The F, Alt and Ctrl+. keys need the terminal to send them: foot does (Neovim turns on its extended key
protocol), so they work here. Check what Neovim receives for a key with `Ctrl-v` in insert mode, then the key.

Two Rider keys are not in Neovim because **foot keeps them for itself** (Ctrl+Shift+R starts a search in the terminal,
Ctrl+Shift+O lists URLs); use `<leader>cR` (refactor) and `<leader>fs` or `gO` (file structure), which are the
same in Rider. `Ctrl+T` (Rider: go to symbol) stays Vim's jump back; go to a symbol with `<leader>fS`.

<!-- check: none -->

| What | Rider's own key | Vim-style, in both | Neovim also has |
|---|---|---|---|
| Go to definition | F12 | `gd` | F12 |
| Go to implementation | Ctrl+F12 | `gri` | Ctrl+F12 |
| Peek the implementations | Alt+F12 | | Alt+F12 |
| Show the usages | Shift+F12 | | Shift+F12 |
| Find usages (a list) | Shift+Alt+F12 | `grr` | Shift+Alt+F12 |
| Go to the type | | `grt` | |
| Rename | F2 | `grn`, `<leader>cr` | F2 |
| Quick fix, actions | Ctrl+. | `gra`, `<leader>ca` | Ctrl+. |
| Refactor this | Ctrl+Shift+R | `<leader>cR` | |
| Quick documentation | Ctrl+K Ctrl+I | `K` | |
| Parameter info | Ctrl+Shift+Space | | Ctrl+Shift+Space (in insert mode also `<C-s>`) |
| Format | Shift+Alt+F | `<leader>cf` | Shift+Alt+F |
| Optimize imports | Shift+Alt+O | | Shift+Alt+O |
| File structure | Ctrl+Shift+O | `gO`, `<leader>fs` | |
| Go to a symbol | Ctrl+T | `<leader>fS` | |
| Next and previous problem | Alt+F8, Shift+F8 | `]d`, `[d` | Alt+F8, Shift+F8 |
| Problems list | Ctrl+Shift+M | `<leader>fd` | Ctrl+Shift+M |
| Back and forward | Alt+Left, Alt+Right | `<C-o>`, `<C-i>` | Alt+Left, Alt+Right |
| Call hierarchy | Shift+Alt+H | | Shift+Alt+H |
| Completion | Ctrl+Space | | Ctrl+Space (insert mode) |

<!-- check: global -->

| Key | Mode | What it does |
|---|---|---|
| `<leader>cf` | n x | Format: `indent` for C, the language server elsewhere |

## Git

<!-- check: global -->

| Key | Mode | What it does |
|---|---|---|
| `<leader>gg` | n | Status (fugitive) |
| `<leader>gc` | n | Commit |
| `<leader>gP` | n | Push |
| `<leader>gF` | n | Pull |
| `<leader>gl` | n | Log |
| `<leader>gB` | n | Blame the whole file |

In a git repository (gitsigns):

<!-- check: git -->

| Key | Mode | What it does |
|---|---|---|
| `]c` | n | Next changed hunk |
| `[c` | n | Previous changed hunk |
| `<leader>gp` | n | Preview the hunk |
| `<leader>gs` | n x | Stage the hunk, or the selected lines |
| `<leader>gr` | n x | Reset the hunk, or the selected lines |
| `<leader>gS` | n | Stage the whole buffer |
| `<leader>gR` | n | Reset the whole buffer |
| `<leader>gb` | n | Blame this line |
| `<leader>gd` | n | Diff against the index |
| `<leader>gq` | n | Send all hunks to the quickfix list |

## Debug

<!-- check: global -->

| Key | Mode | What it does |
|---|---|---|
| `<leader>db` | n | Toggle breakpoint |
| `<leader>dB` | n | Conditional breakpoint |
| `<leader>dc` | n | Start or continue |
| `<leader>dn` | n | Step over (next) |
| `<leader>di` | n | Step into |
| `<leader>do` | n | Step out |
| `<leader>dC` | n | Run to the cursor |
| `<leader>dg` | n | Jump to a line without executing |
| `<leader>dj` | n | Stack frame down |
| `<leader>dk` | n | Stack frame up |
| `<leader>dl` | n | Run the last session again |
| `<leader>dp` | n | Pause |
| `<leader>dr` | n | Toggle the REPL |
| `<leader>dt` | n | Terminate |
| `<leader>dw` | n | Inspect the value under the cursor |
| `<leader>du` | n | Toggle the debug UI |

## Test (neotest)

<!-- check: global -->

| Key | Mode | What it does |
|---|---|---|
| `<leader>tn` | n | Run the nearest test |
| `<leader>tf` | n | Run all tests in the file |
| `<leader>td` | n | Debug the nearest test |
| `<leader>tl` | n | Run the last test again |
| `<leader>ts` | n | Toggle the test summary |
| `<leader>to` | n | Show the output of a test |
| `<leader>tO` | n | Toggle the output panel |
| `<leader>tx` | n | Stop the running test |

## Run and build

<!-- check: global -->

| Key | Mode | What it does |
|---|---|---|
| `<leader>rm` | n | Save and run `make` (in C# files: `dotnet build`, with the errors in the quickfix list) |
| `<leader>rc` | n | Save, compile and run this file with the `compiler` script |
| `<leader>qo` | n | Open the quickfix list |
| `<leader>qc` | n | Close the quickfix list |

## Measure and profile

Works on the current buffer: a C file is built with `-O2 -g` and run, a C# file uses its project's
Release build, anything else asks for a command. Results appear in a terminal split (`q` closes it)
and are saved in `.bench/` next to the code. The workflow is in `~/Projects/scripts/PROFILING.md`.

<!-- check: global -->

| Key | Mode | What it does |
|---|---|---|
| `<leader>mb` | n | Benchmark: timing with warmup, compared with the previous run |
| `<leader>mc` | n | Compare the last two benchmarks |
| `<leader>ms` | n | Counters: `perf stat` for C, runtime counters for C# |
| `<leader>mf` | n | Flame graph (opens in speedscope) |
| `<leader>mg` | n | Open the last recording in hotspot (GUI view of the same data) |
| `<leader>mk` | n | Exact instruction counts per function (callgrind, C only) |
| `<leader>mh` | n | Heap: allocations, peak memory, leaks (C only) |
| `<leader>mr` | n | Repeat the last measurement |
| `<leader>mo` | n | Open the `.bench` results folder (`gx` opens a file) |

## UI toggles

<!-- check: global -->

| Key | Mode | What it does |
|---|---|---|
| `<leader>uw` | n | Line wrap |
| `<leader>un` | n | Relative line numbers |
| `<leader>us` | n | Spell check |
| `<leader>ud` | n | Diagnostics |
| `<leader>uh` | n | Inlay hints |

## Notes (telekasten)

<!-- check: global -->

| Key | Mode | What it does |
|---|---|---|
| `<leader>zp` | n | Notes panel |
| `<leader>zf` | n | Find a note |
| `<leader>zg` | n | Search inside notes |
| `<leader>zd` | n | Today's note |
| `<leader>zn` | n | New note |
| `<leader>zT` | n | New note from a template |
| `<leader>za` | n | Apply a template to the current note |
| `<leader>zz` | n | Follow the link under the cursor |
| `<leader>zb` | n | Backlinks |
| `<leader>zc` | n | Calendar |
| `<leader>zI` | n | Insert an image link |
| `<leader>zt` | n | Toggle a todo |
| `[[` | i | Insert a link to another note |

## LaTeX (vimtex, in `.tex` files)

<!-- check: tex -->

| Key | Mode | What it does |
|---|---|---|
| `<localleader>ll` | n | Start or stop continuous compiling |
| `<localleader>lv` | n | View the PDF |
| `<localleader>lk` | n | Stop compiling |
| `<localleader>lc` | n | Clean build files |
| `<localleader>le` | n | Show errors |
| `<localleader>lt` | n | Table of contents |

## Other

<!-- check: global -->

| Key | Mode | What it does |
|---|---|---|
| `<leader>?` | n | Keys available in this buffer |
| `<leader>in` | n | Browse Nerd Font icons |
| `<leader>iN` | n | Recently used icons |
| `<Esc><Esc>` | t | Leave terminal mode |
