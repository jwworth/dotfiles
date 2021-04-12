#!/bin/zsh

# Initialize autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

# Path exports
# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"

# Add Visual Studio Code to my path as `code`
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Shorthands for my favorite editor
alias v='vim'
alias vi='vim'

# Find commands I type often so I can alias them
alias typeless='history n 20000 | sed "s/.*  //"  | sort | uniq -c | sort -g | tail -n 100'

# Git ---------------------- {{{
# Fast-forward my branch to master's HEAD
alias gmr='git checkout master && git pull --rebase && git checkout - && git rebase master'

# Interactively rebase a feature branch off the divergence from master
alias grim='git rebase -i master'

# Fast-forward my branch and open an interactive Git rebase
alias mgrim='gmr && grim'

# History ---------------------- {{{
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
# }}}

# Hashrocket aliases
alias gap='git add -p'
alias gb='git branch'
alias gc='git commit -v'
alias gca='git commit -a -v'
alias gcl='git clean -f -d'
alias gco='git checkout'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdh='git diff HEAD'
alias gl='git pull'
alias glg='git log --graph --oneline --decorate --color --all'
alias glod='git log --oneline --decorate'
alias glp='git log -p'
alias gnap='git add -N --ignore-removal . && gap && gref'
alias gp='git push'
alias gplease='git push --force-with-lease'
alias gpr='git pull --rebase'
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grim='git rebase -i master'
alias gst='git status'
alias reset-authors='git commit --amend --reset-author -C HEAD'
# }}}

# Rails ---------------------- {{{
# Hashrocket aliases
alias be='bundle exec'
alias groutes='rake routes | grep $@'
alias sc='rails console'
alias ss='rails server'
# }}}

# File management ---------------------- {{{
# Hashrocket aliases
alias ..='cd ..'
alias cd..='cd ..'
alias l="ls -F -G -lah"
alias la="ls -a"
alias ll='ls -l'
alias lsd='ls -ld *(-/DN)'
alias md='mkdir -p'
alias rd='rmdir'
# }}}

# Update my brew
alias brewu='brew update && brew upgrade && brew cleanup && brew prune && brew doctor'

# Open the hostfile
alias eetc='sudo vim /etc/hosts'

# Alias my JS package manager of choice
alias y='yarn'

# Alias Elixir mix commands
alias xdg='mix deps.get'

# Functions
# Run all of the tests that have changed on my current branch (Ruby).
# Usage: `$ changespec master`
function changespec () {
  git diff $@ --diff-filter=d --name-only *spec.rb | xargs rspec
}

# Enable Erlang history (OTP 20+)
export ERL_AFLAGS="-kernel shell_history enabled"

# Set up fuzzy finding
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
