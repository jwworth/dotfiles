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

# Initialize autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

# Path exports
# Add RVM to PATH
export PATH="$PATH:$HOME/.rvm/bin"

# Shorthands for my favorite editor
alias v='vim'
alias vi='vim'

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
alias gcl='git clean -f -d'
alias gco='git checkout'
alias gcom='git checkout master'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdh='git diff HEAD'
alias gl='git pull'
alias glg='git log --graph --oneline --decorate --color --all'
alias glod='git log --oneline --decorate'
alias glp='git log -p'
alias gmr='git checkout master && git pull --rebase && git checkout - && git rebase master'
alias gnap='git add -N --ignore-removal . && gap && gref'
alias gp='git push'
alias gplease='git push --force-with-lease'
alias gpr='git pull --rebase'
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grim='git rebase -i master'
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
alias groutes='rake routes | rg $@'
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

# Aliases my JS package manager of choice
alias y='yarn'
alias yj='yarn jest'

# Functions
# Run all of the tests that have changed on my current branch (Ruby).
# Usage: `$ changespec master`
function changespec () {
  git diff $@ --diff-filter=d --name-only '*spec.rb' | xargs rspec
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

# Set up fuzzy finding
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Prefer exhuberant ctags to alternatives
alias ctags=/usr/local/bin/ctags

# Load asdf
. /usr/local/opt/asdf/libexec/asdf.sh

# Load Zsh plugins
source ~/alias-tips/alias-tips.plugin.zsh

# Add items not included in source control
if [ -f .zshrc.secret ]; then
  source .zshrc.secret
fi
