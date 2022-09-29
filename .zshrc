# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt beep extendedglob nomatch notify
export KEYTIMEOUT=1
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename $HOME/.zshrc

# autoload -Uz compinit
# compinit
# # End of lines added by compinstall

# Disable zsh correct
unsetopt correct_all

# Path to your oh-my-zsh installation.
export ZSH="/Users/nmoya/.oh-my-zsh"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$JAVA_HOME/jre/bin:$PATH
export PATH=$HOME/.tool_scripts:$PATH
export PATH=/usr/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=/usr/local/bin:$PATH

alias ls="ls -G"
alias cd..="cd .."
alias cdr="cd ~/Repos"
alias ra144678="ssh ra144678@ssh.students.ic.unicamp.br"
alias urldiff="python ~/Dropbox/Personal/Softwares/urlDiff.py"
alias simplehttpserver="python -m SimpleHTTPServer"
alias adb="~/Library/Android/sdk/platform-tools/adb"
alias gitpurge='git branch --merged | grep -v "\*" | grep -v "master" | grep -v "develop" | grep -v "staging" | xargs -n 1 git branch -d'
alias gitpurgeexceptmaster='git branch | egrep -v "(master|\*)" | xargs git branch -D'
alias gcm="git checkout master"
alias gpr="git pull --rebase"
alias grc="git rebase --continue"
alias grm="git rebase master"
alias lynx="lynx -accept_all_cookies" 
alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
alias vscode="/usr/bin/code"
alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"


# Defer initialization of nvm until nvm, node or a node-dependent command is
# run. Ensure this block is only run once if .bashrc gets sourced multiple times
# by checking whether __init_nvm is a function.
if [ -s "$HOME/.nvm/nvm.sh" ] && [ ! "$(type __init_nvm)" = function ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  declare -a __node_commands=('nvm' 'node' 'npm' 'yarn' 'gulp' 'grunt' 'webpack')
  function __init_nvm() {
    for i in "${__node_commands[@]}"; do unalias $i; done
    . "$NVM_DIR"/nvm.sh
    unset __node_commands
    unset -f __init_nvm
  }
  for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
fi

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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/nmoya/Downloads/google-cloud-sdk/path.bash.inc' ]; then source '/Users/nmoya/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nmoya/Downloads/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/nmoya/Downloads/google-cloud-sdk/completion.bash.inc'; fi

# partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git dotenv)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# Use vi mode to edit commands
bindkey -v
# Up arrow will complete current command based in history
# You can use ctrl+v<KEY> to find the code of a key
# To know the code of a key, execute cat, press enter, press the key, then Ctrl+C.
bindkey "^[OA" history-beginning-search-backward
bindkey "^[OB" history-beginning-search-forward
bindkey "^[OF" end-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[[3~" delete-char
