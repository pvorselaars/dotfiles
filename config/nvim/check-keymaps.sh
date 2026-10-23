#!/bin/bash
# Checks that every key in KEYMAPS.md is really mapped, using a suitable file for each context.
# Needs network-free tools only: nvim, git. The lsp context needs lua-language-server (installed by mason).
here=$(cd "$(dirname "$(readlink -f "$0")")" && pwd)
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
export KEYMAPS_MD="${KEYMAPS_MD:-$here/KEYMAPS.md}"
status=0

run() { # context file...
    local ctx=$1; shift
    CHECK_CONTEXT=$ctx timeout 90 nvim --headless "$@" -c "luafile $here/check-keymaps.lua" > "$tmp/out" 2>&1
    local rc=$?
    grep -v '^$' "$tmp/out"
    return $rc
}

mkdir -p "$tmp/lua" "$tmp/repo"
echo '{}' > "$tmp/lua/.luarc.json"; printf 'local x = 1\nprint(x)\n' > "$tmp/lua/a.lua"
( cd "$tmp/repo" && git init -q && git config user.email t@t && git config user.name t \
    && printf 'one\ntwo\n' > f.txt && git add f.txt && git commit -q -m init && printf 'ONE\ntwo\n' > f.txt )
printf '\\documentclass{article}\n\\begin{document}\nhi\n\\end{document}\n' > "$tmp/doc.tex"

( cd "$tmp" && run global ) || status=1
( cd "$tmp/lua" && run lsp a.lua ) || status=1
( cd "$tmp/repo" && run git f.txt ) || status=1
( cd "$tmp" && run tex doc.tex ) || status=1
exit $status
