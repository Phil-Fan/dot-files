# 别名配置模块
# 文件: ~/.zsh_config/04-aliases.zsh

# ========== 现代化 CLI 工具别名 ==========
alias cat='bat --paging=never'
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --git'
alias la='eza -lha --git'
alias grep='rg --smart-case'
alias f='fd'

# ========== 编辑器别名 ==========
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias lg='lazygit'
alias cc='claude'
alias cx='codex'
alias oc='opencode'
alias hc='happy-coder'

# -------------------------------- #
# Node Package Manager
# -------------------------------- #
# https://github.com/antfu/ni

alias nio="ni --prefer-offline"
alias s="nr start"
alias d="nr dev"
alias b="nr build"
alias bw="nr build --watch"
alias t="nr test"
alias tu="nr test -u"
alias tw="nr test --watch"
alias w="nr watch"
alias lint="nr lint"
alias lintf="nr lint --fix"
alias release="nr release"
alias re="nr release"

# -------------------------------- #
# Git
# -------------------------------- #

alias g='git'
alias grt='cd "$(git rev-parse --show-toplevel)"'

alias gs='git status'
alias gp='git push'
alias gpf='git push --force'
alias gpl='git pull --rebase'
alias gcl='git clone'
alias gst='git stash'
alias grm='git rm'
alias gmv='git mv'

alias main='git checkout main'

alias gck='git checkout'
alias gckb='git checkout -b'

alias gb='git branch'
alias gbd='git branch -d'

alias grb='git rebase'
alias grbom='git rebase origin/master'
alias grbc='git rebase --continue'

alias gl='git log'
alias graph='git log --oneline --graph --all'

alias grh='git reset HEAD'
alias grh1='git reset HEAD~1'

alias ga='git add'
alias gA='git add -A'

alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -a'
alias gcam='git add -A && git commit -m'

alias gxn='git clean -dn'
alias gx='git clean -df'

alias gsha='git rev-parse HEAD | pbcopy'

alias ghci='gh run list -L 1'

function glp() {
  git --no-pager log -$1
}

function gd() {
  if [[ -z $1 ]] then
    git diff --color | diff-so-fancy
  else
    git diff --color $1 | diff-so-fancy
  fi
}

function gdc() {
  if [[ -z $1 ]] then
    git diff --color --cached | diff-so-fancy
  else
    git diff --color --cached $1 | diff-so-fancy
  fi
}

# -------------------------------- #
# Directories
#
# I put
# `~/c` for my courses & homework
# `~/l` for lab
# `~/i` for my projects
# `~/f` for forks
# -------------------------------- #

function pr() {
  if [ $1 = "ls" ]; then
    gh pr list
  else
    gh pr checkout $1
  fi
}

function dir() {
  mkdir $1 && cd $1
}

function clone() { # clone a repository from GitHub
  gh repo clone "$@" || return

  local dir="${2:-$(basename "$1" .git)}"

  if [[ -d "$dir" ]]; then
    cd "$dir"
  fi
}

function hw() {
  cd ~/c/$1
}

function lab() {
  cd ~/l/$1
}

function pj() {
  cd ~/i/$1
}

function fork() {
  cd ~/f/$1
}

# ---- Clone helpers ----

clonehw() {
  hw || return
  clone "$@" || return
  cursor .
  cd - > /dev/null
}

clonel() {
  lab || return
  clone "$@" || return
  cursor .
  cd - > /dev/null
}

clonei() {
  pj || return
  clone "$@" || return
  cursor .
  cd - > /dev/null
}

clonef() {
  fork || return
  clone "$@" || return
  cursor .
  cd - > /dev/null
}


# ---- Cursor open helpers ----

chw() {
  hw "$1" || return
  cursor .
  cd - > /dev/null
}

clab() {
  lab "$1" || return
  cursor .
  cd - > /dev/null
}

cpj() {
  pj "$1" || return
  cursor .
  cd - > /dev/null
}

cfork() {
  fork "$1" || return
  cursor .
  cd - > /dev/null
}

# ========== 导航别名 ==========
alias ..="cd .."
alias ...="cd ../.."

# ========== 平台特定别名 ==========
if [[ "$OSTYPE" == darwin* ]]; then
    alias typora="open -a Typora"
fi
