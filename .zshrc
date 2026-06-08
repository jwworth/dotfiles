#!/bin/zsh
# Uncomment and run `zprof` to profile startup
# More info: https://htr3n.github.io/2018/07/faster-zsh/
# zmodload zsh/zprof

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
autoload -Uz compinit
if [[ -f ~/.zcompdump ]]; then
  compinit -C
else
  compinit
fi

# Style the prompt
autoload -Uz vcs_info
autoload -U colors; colors
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes false
zstyle ':vcs_info:git*' formats "%{$fg[yellow]%}%r/%S%{$fg[white]%} %{$fg[green]%}%b%{$reset_color%} "

precmd() {
  git rev-parse --is-inside-work-tree &>/dev/null || {
    vcs_info_msg_0_=''
    return
  }

  vcs_info
}

setopt prompt_subst
PROMPT='${vcs_info_msg_0_}%# '

# Shorthand for my favorite editor
alias vim='/opt/homebrew/bin/vim'

# Shorthand for my python
alias python="python3"

# Shorthand for Node REPL
alias jsc="node"

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
# Attach to or create a tmux session. h/t Hashrocket Dotmatrix
# Usage: mux blog
mux() {
  if [ -z "$1" ]; then
    echo "Usage: mux <session-name>"
    return 1
  fi

  local session_name="$1"
  local code_dir="$HOME/code/$session_name"
  local session_dir="$PWD"

  if tmux has-session -t "$session_name" 2>/dev/null; then
    tmux attach-session -t "$session_name"
  else
    if [ -d "$code_dir" ]; then
      session_dir="$code_dir"
    fi

    tmux new-session -d -s "$session_name" -c "$session_dir" &&
      tmux split-window -h -t "$session_name:0" -c "$session_dir" &&
      tmux send-keys -t "$session_name:0.1" 'vim' C-m &&
      tmux select-pane -t "$session_name:0.1" &&
      tmux attach-session -t "$session_name"
  fi
}

# Format JSON in place with jq
# Usage: prettify filename.json
prettify() {
  local temp_file
  temp_file=$(mktemp) &&
    jq . < "$1" > "$temp_file" &&
    mv -- "$temp_file" "$1"
}

# Open a canvas for drawing
draw() {
  open 'https://excalidraw.com/'
}

# Test that Ruby on Rails migrations work forward and backward
# h/t Hashrocket Dotmatrix
# usage: twiki
twiki() {
  bin/rails db:migrate && bin/rails db:migrate:redo
}
# }}}

# Autoloading ---------------------- {{{
# Load autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
# }}}

# Activate packages ---------------------- {{{
# Load fuzzy finding
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
fi

# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"

# Add NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Load private ZSH settings, if present
if [ -f "~/.zshrc.secret" ]; then
  source "~/.zshrc.secret"
fi
# }}}
