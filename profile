export PS1=' \W \$ '
export EDITOR=vim
export PATH=$PATH:$HOME/bin

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

set -o vi
