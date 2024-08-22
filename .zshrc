#!/bin/zsh

# Enable emacs keybindings
bindkey -e

# Set default apps
export PAGER='less'
export EDITOR='vim'
export PSQL_EDITOR='vim -c"setf sql"'

# Color the terminal
export CLICOLOR=1
export LSCOLORS=Dxfxcxdxbxegedabadacad
export ZLS_COLORS=$LSCOLORS
export LC_CTYPE=en_US.UTF-8
export LESS=FRX

# Initialize the ZSH completion system
autoload -U compinit; compinit

# Style the prompt
autoload -Uz vcs_info
autoload -U colors; colors
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git*' formats "%{$fg[yellow]%}%r/%S%{$fg[white]%} %{$fg[green]%}%b%{$reset_color%}%m%u%c%{$reset_color%} "
precmd() { vcs_info }
setopt prompt_subst
PROMPT='${vcs_info_msg_0_}%# '

# Shorthand for my favorite editor
alias vim='/opt/homebrew/bin/vim'

# Find commands I type often so I can alias them
alias typeless='history n 20000 | sed "s/.*  //"  | sort | uniq -c | sort -g | tail -n 100'

# Git ---------------------- {{{
# Reset empty files
gref() {
  command git --no-pager diff --cached --stat | command grep "|\s*0$" | awk '{system("command git reset " $1)}'
}

alias gap='git add -p'
alias gb='git branch'
alias gc='git commit -v'
alias gcheddar='git commit --amend -CHEAD'
alias gco='git checkout'
alias gdoff='git reset HEAD\^'
alias glg='git log --graph --oneline --decorate --color --all'
alias glod='git log --oneline --decorate'
alias glp='git log -p'
alias gnap='git add -N --ignore-removal . && gap && gref'
alias gp='git push'
alias gplease='git push --force-with-lease'
alias gpr='git pull --rebase'
alias gput='git push origin HEAD'
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grim='git rebase -i main'
alias gst='git status'
# }}}

# History ---------------------- {{{
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
unsetopt HIST_VERIFY
# }}}

# File management ---------------------- {{{
alias ..='cd ..'
# }}}

# Functions ---------------------- {{{
# Create a tmux session to my specifications
function mux() {
  tmux new-session \; rename-session ${1} \; new-window -n server \; last-window \; split-window \; select-layout main-vertical &>/dev/null \; send-keys -t $name:0.1 'vim .' C-m \; attach
}

# Generic timestamped Git commit
function checkpoint() {
  git add . && git commit -m "Checkpoint $(date)"
}

# Upgrade Node dependency on a named branch
function npmupgrade() {
  npm upgrade $1 && git checkout -b chore/upgrade-$1 && git add . && git commit -m "Upgrade $1"
}

# Change the terminal color when I'm in a remote console
function set_color() {
  local R=$1
  local G=$2
  local B=$3
  /usr/bin/osascript <<EOF
tell application "iTerm"
  tell current session of current window
    set background color to {$(($R*65535/255)), $(($G*65535/255)), $(($B*65535/255))}
  end tell
end tell
EOF
}

function reset_colors() {
  set_color 0 0 0
}

# Load function variables I don't want in version control
if [ -f ~/.zshrc.secret ]; then
  source ~/.zshrc.secret
fi

# Open a prod console
function prod_console() {
  set_color 46 0 0
  heroku console -a $prodapi
  reset_colors
}

# Open a staging console
function staging_console() {
  set_color 46 46 0
  heroku console -a $stagingapi
  reset_colors
}

# Open my personal GitHub review page
# Example variable:
# reviewpage=https://github.com/pulls?q=is%3Aopen+is%3Apr+review-requested%3Ajwworth+archived%3Afalse+user%3Ahashrocket'
function rr() {
   open $reviewpage
}

# Open my a PR on my current Git branch
# Example variable:
# prpage='https://github.com/hashrocket/hashrocket-rb/compare'
function pr() {
  open "$prpage/$(git branch --show-current)?expand=1"
}

# Open my Pivotal Tracker
# Example variable:
# pivotal='https://www.pivotaltracker.com/n/projects/2582520'
function pt() {
  open $pivotal
}
# }}}

# Autoloading ---------------------- {{{
# Load autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

# Load fuzzy finding
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
fi

# Load NVM
export NVM_DIR="$HOME/.nvm"
if [ -f "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
fi

if [ -f "$NVM_DIR/bash_completion" ]; then
  source "$NVM_DIR/bash_completion"
fi

# Load Zsh plugins
if [ -f ~/alias-tips/alias-tips.plugin.zsh ]; then
  source ~/alias-tips/alias-tips.plugin.zsh
fi
# }}}

# Extend PATH ---------------------- {{{
# Add RVM
export PATH="$PATH:$HOME/.rvm/bin"
# }}}
