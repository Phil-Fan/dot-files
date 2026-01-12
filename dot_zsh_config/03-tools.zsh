# 现代化 CLI 工具配置模块
# 文件: ~/.zsh_config/03-tools.zsh

# ============ Neovim 编辑器配置 ============
if command -v nvim >/dev/null 2>&1; then
    export EDITOR="nvim"
    export VISUAL="nvim"
    export GIT_EDITOR="nvim"
    export MANPAGER="nvim +Man!"
fi

# Vim 模式快捷键（Ctrl+Space 进入命令模式）
bindkey '^ ' vi-cmd-mode

# ============ Bat (Cat Clone) 配置 ============
# 默认 man pager，会被 nvim 覆盖
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# ============ fzf (Fuzzy Finder) 配置 ============
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# ============ Autojump 智能目录跳转 ============
[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh

# ============ EnvTools: 环境信息显示 ============
# Detect shell version
if [ -n "$BASH_VERSION" ]; then
    SHELL_INFO="Bash ${BASH_VERSION%%.*}"
elif [ -n "$ZSH_VERSION" ]; then
    SHELL_INFO="Zsh ${ZSH_VERSION%%.*}"
else
    SHELL_INFO="Shell $(basename $SHELL)"
fi

# ANSI color codes
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}>>> TOPCODER FULLSTACK EnvTools (${SHELL_INFO})${NC}"

# Detect Node.js and its manager
if command -v node >/dev/null 2>&1; then
    NODE_PATH=$(command -v node)
    NODE_VERSION=$(node --version 2>/dev/null)

    if echo "$NODE_PATH" | grep -q "volta"; then
        NODE_MANAGER="volta"
    elif echo "$NODE_PATH" | grep -q "fnm"; then
        NODE_MANAGER="fnm"
    elif echo "$NODE_PATH" | grep -q "nvm"; then
        NODE_MANAGER="nvm"
    else
        NODE_MANAGER="system"
    fi

    echo -e "    ${CYAN}Node: ${NODE_VERSION} (${NODE_MANAGER})${NC}"
else
    echo -e "    ${YELLOW}Node.js: Not found in PATH${NC}"
fi
