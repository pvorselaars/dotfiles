# long-command.bash, sourced from ~/.bashrc: a notification when a long command has finished.
#
# When a command that took LONG_COMMAND_SECONDS (default 30) or more finishes while this terminal is not
# the focused window in sway, mako shows the command, how long it took and whether it worked.
# Commands that are long by nature are skipped (editors, pagers, ssh, watch, ...): LONG_COMMAND_IGNORE
# is the list of their names. Nothing happens outside sway, in a script, or without notify-send.

[ -n "$PS1" ] || return
[ -z "$_LC_INSTALLED" ] || return                  # sourced twice: install once
command -v notify-send >/dev/null && command -v swaymsg >/dev/null || return
_LC_INSTALLED=1

: "${LONG_COMMAND_SECONDS:=30}"
: "${LONG_COMMAND_IGNORE:=vi vim nvim less man ssh top htop btop watch tail journalctl fzf lazygit zathura mpv ytermusic fg}"

_lc_armed=0         # 1 while the prompt is waiting for a command; the first command after that starts the clock
_lc_start=0
_lc_command=""

# DEBUG trap: runs before every simple command, also inside functions and in PROMPT_COMMAND, so only the
# first one after the prompt counts
_lc_before() {
    [ "$_lc_armed" = 1 ] || return 0
    case $BASH_COMMAND in _lc_*) return 0 ;; esac   # our own functions are not the command
    _lc_armed=0
    _lc_start=$EPOCHSECONDS
    _lc_command=$BASH_COMMAND
}

# _lc_terminal_focused: succeed when the window of this terminal is the one with the focus
_lc_terminal_focused() {
    local focused pid
    focused=$(swaymsg -t get_tree 2>/dev/null | jq -r '.. | select(.focused? == true) | .pid' | head -n 1)
    [ -n "$focused" ] || return 1
    pid=$$
    while [ -n "$pid" ] && [ "$pid" -gt 1 ]; do      # this shell, its parent, ...: one of them is the terminal
        [ "$pid" = "$focused" ] && return 0
        pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
    done
    return 1
}

# _lc_duration SECONDS: "45s", "3m05s", "1h02m"
_lc_duration() {
    local s=$1
    if   [ "$s" -ge 3600 ]; then printf '%dh%02dm' $((s / 3600)) $((s % 3600 / 60))
    elif [ "$s" -ge 60 ];   then printf '%dm%02ds' $((s / 60)) $((s % 60))
    else printf '%ds' "$s"
    fi
}

# first in PROMPT_COMMAND: the status of the command that just ended is still in $?
_lc_after() {
    local status=$? elapsed line word duration
    if [ "$_lc_armed" = 0 ] && [ -n "$_lc_command" ] && [ -n "$SWAYSOCK" ]; then
        elapsed=$((EPOCHSECONDS - _lc_start))
        if [ "$elapsed" -ge "$LONG_COMMAND_SECONDS" ]; then
            line=$(HISTTIMEFORMAT= history 1 2>/dev/null | sed 's/^ *[0-9]* *//')
            [ -n "$line" ] && _lc_command=$line           # the whole line you typed, not only its first command
            word=${_lc_command%% *}
            word=${word##*/}
        fi
        if [ "$elapsed" -ge "$LONG_COMMAND_SECONDS" ] && [[ " $LONG_COMMAND_IGNORE " != *" $word "* ]] \
            && ! _lc_terminal_focused; then
            duration=$(_lc_duration "$elapsed")
            if [ "$status" -eq 0 ]; then
                notify-send -a terminal "Done in $duration" "${_lc_command:0:80}"
            else
                notify-send -a terminal -u critical "Failed (exit $status) after $duration" "${_lc_command:0:80}"
            fi
        fi
    fi
    _lc_command=""
    return $status                                    # the other PROMPT_COMMAND parts and the prompt see the real status
}

# last in PROMPT_COMMAND: from here on, the next command starts the clock
_lc_arm() { _lc_armed=1; }

trap '_lc_before' DEBUG
if [[ $(declare -p PROMPT_COMMAND 2>/dev/null) == "declare -a"* ]]; then
    PROMPT_COMMAND=(_lc_after "${PROMPT_COMMAND[@]}" _lc_arm)
else
    PROMPT_COMMAND="_lc_after${PROMPT_COMMAND:+;$PROMPT_COMMAND};_lc_arm"
fi
