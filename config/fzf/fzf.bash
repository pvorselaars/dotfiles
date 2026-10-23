# fzf setup, sourced from ~/.bashrc: key bindings, One Dark Darker colours (same as sway) and a few pickers.

command -v fzf >/dev/null || return

eval "$(fzf --bash)"   # Ctrl-R history, Ctrl-T file, Alt-C cd

export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_DEFAULT_OPTS="--height=60% --layout=reverse --border --info=inline \
--color=bg:#1f2329,bg+:#282c34,fg:#a0a8b7,fg+:#a0a8b7,hl:#4fa6ed,hl+:#4fa6ed \
--color=info:#7a818e,prompt:#bf68d9,pointer:#bf68d9,marker:#e55561,spinner:#bf68d9,header:#7a818e,border:#535965"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=down:3:wrap"
export FZF_ALT_C_OPTS="--preview 'ls -A --color=always {}'"

# rgf [pattern]: live ripgrep, Enter opens the match in nvim
rgf() {
    local rg='rg --column --line-number --no-heading --color=always --smart-case'
    fzf --ansi --disabled --query "${*:-}" \
        --bind "start:reload:$rg {q} || true" \
        --bind "change:reload:sleep 0.1; $rg {q} || true" \
        --delimiter : \
        --preview 'bat --color=always --highlight-line {2} {1}' \
        --preview-window 'right,60%,+{2}+3/3' \
        --bind 'enter:become(nvim {1} +{2})'
}

# gb: switch git branch (local and remote), with the latest commits as preview
gb() {
    local b
    b=$(git branch --all --sort=-committerdate --format='%(refname:short)' |
        fzf --preview 'git log --oneline --color=always -20 {}') || return
    git switch "${b#origin/}"
}

# glf: browse the git log, preview the diff of the selected commit
glf() {
    git log --color=always --pretty=format:'%C(yellow)%h%Creset %C(blue)%cd%Creset %s %C(dim)%an%Creset' --date=short |
        fzf --ansi --no-sort --preview 'git show --color=always {1}'
}

# fkill [signal]: pick processes (Tab for several) and kill them
fkill() {
    local pids
    pids=$(ps -u "$USER" -o pid=,etime=,args= | fzf -m --header 'Tab: select several' | awk '{print $1}') || return
    [ -n "$pids" ] && echo "$pids" | xargs kill "-${1:-TERM}"
}
