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
alias v='vim'
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
alias gca='git commit -a -v'
alias gcheddar='git commit --amend -CHEAD'
alias gcl='git clean -f -d'
alias gco='git checkout'
alias gcom='git checkout main'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdh='git diff HEAD'
alias gdoff='git reset HEAD\^'
alias gl='git pull'
alias glg='git log --graph --oneline --decorate --color --all'
alias glod='git log --oneline --decorate'
alias glp='git log -p'
alias gmr='git checkout main && git pull --rebase && git checkout - && git rebase main'
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
alias mgrim='gmr && grim'
alias reset-authors='git commit --amend --reset-author -C HEAD'
# }}}

# History ---------------------- {{{
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
# }}}

# Rails ---------------------- {{{
alias be='bundle exec'
alias groutes='rails routes | rg $@'
alias sc='rails console'
alias ss='rails server'
# }}}

# File management ---------------------- {{{
alias ..='cd ..'
alias cd..='cd ..'
alias l='ls -F -G -lah'
alias la='ls -a'
alias ll='ls -l'
alias lsd='ls -ld *(-/DN)'
alias md='mkdir -p'
alias rd='rmdir'
# }}}

# Yarn ---------------------- {{{
alias y='yarn'
alias yj='yarn jest'
alias yo='yarn outdated'
# }}}

# Functions ---------------------- {{{
# Create a tmux session to my specifications
function mux() {
  tmux new-session \; rename-session ${1} \; new-window -n server \; last-window \; split-window \; select-layout main-vertical &>/dev/null \; send-keys -t $name:0.1 'vim .' C-m \; attach
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

# Example use
function prod_console() {
  set_color 46 0 0
  heroku console -a your-api # Change to your API
  reset_colors
}

# Run all of the tests that have changed on my current branch (Ruby).
# Usage: `$ changespec main`
function changespec() {
  git diff $@ --diff-filter=d --name-only '*spec.rb' | xargs rspec
}

# Print the last exit status
function print_status() {
  echo $?
}

# Migrate an ActiveRecord database, roll it back, and migrate again.
function twiki () {
  rake db:migrate && rake db:migrate:redo && rake db:test:prepare
}

# Update Homebrew
function updateHomebrew () {
  set -x
  brew update
  brew upgrade
  brew cleanup -s
  brew doctor
  brew missing
}
# }}}

# Autoloading ---------------------- {{{
# Load autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

# Load fuzzy finding
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
fi

# Load asdf
if [ -f /usr/local/opt/asdf/libexec/asdf.sh ]; then
  source /usr/local/opt/asdf/libexec/asdf.sh
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

# Add secrets not included in source control
if [ -f .zshrc.secret ]; then
  source .zshrc.secret
fi
# }}}

# Extend PATH ---------------------- {{{
# Add RVM
export PATH="$PATH:$HOME/.rvm/bin"

# Add PostgreSQL
export PATH="/opt/homebrew/opt/postgresql@13/bin:$PATH"
# }}}
