export PS1=' \W \$ '
export EDITOR=nvim
export PATH=$PATH:$HOME/bin

set -o vi

alias k=kubectl
alias kns='kubectl config set-context --current --namespace '
alias kctx='kubectl config use-context '
alias kgr='kubectl get all,cm,secret,ing '

alias gs='git status'
alias gc='git commit -m '
alias gca='git commit -am '
alias gp='git push'
alias g='git pull'
alias gl='git --no-pager log --pretty=tformat:"%cn %cd %h %s"'
alias gd='git diff'
