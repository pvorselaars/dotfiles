export PS1=' \W \$ '
export EDITOR=vim
export PATH=$PATH:$HOME/bin

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

set -o vi

alias k=kubectl
alias kns='kubectl config set-context --current --namespace '
alias kctx='kubectl config use-context '
alias kgr='kubectl get all,cm,secret,ing '
