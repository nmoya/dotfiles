#Adapting to homebrew be executed first
export PATH=$HOME/.scripts:${PATH}
HISTSIZE=50000

export GREP_COLOR="4;33"
export CLICOLOR="auto"

alias ls="ls --color"
alias ll="ls -l"
alias la="ls -a"
alias cd..="cd .."
alias tarbz2="tar -jcvf"
alias cdr="cd ~/Repos"
alias c="wl-copy"
alias p="wl-paste"
alias ra144678="ssh ra144678@ssh.students.ic.unicamp.br"
alias gpr="git pull --rebase"
alias grc="git rebase --continue"
alias grm="git rebase master"
alias gitpurge='git branch --merged | grep -v "\*" | grep -v "master" | grep -v "develop" | grep -v "staging" | xargs -n 1 git branch -d'
alias gitpurgeexceptmaster='git branch | egrep -v "(master|\*)" | xargs git branch -D'

# Git branch in prompt.
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\u@\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] "

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion