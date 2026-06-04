#Adapting to homebrew be executed first
export PATH=/usr/local/bin:$HOME/.scripts:/usr/bin:/usr/local/sbin:$HOME/Library/Android/sdk/tools/:${PATH}
HISTSIZE=50000

export PS1="$ \u@Local "
export GREP_COLOR="4;33"
export CLICOLOR="auto"

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

alias ls="ls --color"
alias ll="ls -l"
alias la="ls -a"
alias cd..="cd .."
alias pipall="pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U"
alias tarbz2="tar -jcvf"
alias cdift="cd ~/Documents/IFT"
alias cdrift="cd ~/Documents/IFT/demo/RelaxedIFT"
alias cddropbox="cd ~/Dropbox"
alias cdh="cd ~"
alias cdr="cd ~/Repos"
alias cdx="cd ~/Repos/vx-apps/"
alias cda="cd ./app/src/main/assets/"
alias c="pbcopy"
alias p="pbpaste"
alias android-studio="/usr/bin/android-studio/bin/studio.sh"
alias ra144678="ssh ra144678@ssh.students.ic.unicamp.br"
alias sms="python ~/Dropbox/Personal/Softwares/sendSMS.py"
alias urldiff="python ~/Dropbox/Personal/Softwares/urlDiff.py"
alias virtualenv="python ~/Dropbox/Personal/Softwares/virtualenv-1.11.4/virtualenv.py"
alias simplehttpserver="python -m SimpleHTTPServer"
alias adb="~/Android/Sdk/platform-tools/adb"
alias mongo-start="sudo systemctl start mongodb"
alias mongo-stop="sudo systemctl stop mongodb"
alias mongo-status="sudo systemctl status mongodb"
alias mongo-shell="mongo"
alias gitmerged="git branch --merged | grep -v "\*" | grep -v master | grep -v dev | xargs -n 1 git branch -d"
alias gpr="git pull origin master --rebase"
alias grc="git rebase --continue"
source ~/git-completion.bash

# Git branch in prompt.
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\u@\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] "

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Added by to (https://github.com/nmoya/to.git)
to() {
  out=`/home/nmoya/Repos/to/to.py $@`
  if [[ $out == c* ]]
  then
    eval $out
  else
    echo $out
  fi
}
