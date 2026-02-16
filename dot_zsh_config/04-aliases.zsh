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

# ========== Git 别名 ==========
alias g="git"
alias gc="git commit -m"

# ========== 导航别名 ==========
alias ..="cd .."
alias ...="cd ../.."

# ========== 平台特定别名 ==========
if [[ "$OSTYPE" == darwin* ]]; then
    alias typora="open -a Typora"
fi
