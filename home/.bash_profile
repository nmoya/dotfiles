#Adapting to homebrew be executed first
export PATH=$HOME/.tool_scripts:$HOME/bin:${PATH}
HISTSIZE=50000

export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;33"
export CLICOLOR="auto"

alias ls="ls -G"
alias ll="ls -l"
alias la="ls -a"
alias cd..="cd .."
alias tarbz2="tar -jcvf"
alias cdr="cd ~/Repos"
alias cda="cd ./app/src/main/assets/"
alias ra144678="ssh ra144678@ssh.students.ic.unicamp.br"
alias gitpurge='git branch --merged | grep -v "\*" | grep -v "master" | grep -v "develop" | grep -v "staging" | xargs -n 1 git branch -d'
alias gitpurgeexceptmaster='git branch | egrep -v "(master|\*)" | xargs git branch -D'
alias gcm="git checkout master"
alias gpr="git pull --rebase"
alias grc="git rebase --continue"
alias grm="git rebase master"
alias gpo="git push origin "
alias lynx="lynx -accept_all_cookies" 
alias jsondiff="node ~/Repos/jsondiff/jsondiff.js"
alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"

# http://apple.stackexchange.com/questions/55875/git-auto-complete-for-branches-at-the-command-line
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

if [ -f ~/Repos/git-completion.bash ]; then
  . ~/Repos/git-completion.bash
fi

# Git branch in prompt.
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] "
# The next line updates PATH for the Google Cloud SDK.
# source '/Users/nmoya/Repos/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
# source '/Users/nmoya/Repos/google-cloud-sdk/completion.bash.inc'

export NVM_DIR="/Users/nmoya/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Added by to (https://github.com/nmoya/to.git)
to() {
  out=`python3 /Users/nmoya/Repos/to/to.py $@`
  if [[ $out == c* ]]
  then
    eval $out
  else
    echo $out
  fi
}

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

alias dotfiles='/usr/bin/git --git-dir=/Users/nmoya/.dotfiles/ --work-tree=/Users/nmoya'