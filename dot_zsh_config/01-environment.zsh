# 基础环境配置模块
# 文件: ~/.zsh_config/01-environment.zsh

# ============================================
# Homebrew 配置
# ============================================
# macOS Apple Silicon
if [[ -d "/opt/homebrew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
# macOS Intel
elif [[ -d "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
# Linux Homebrew
elif [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# 用户信息
export DEFAULT_USER="$(whoami)"

# 通用 PATH
export PATH="$HOME/.local/bin:$PATH"

# 默认编辑器（后续会被 neovim 覆盖）
export EDITOR="${EDITOR:-vi}"
export VISUAL="${VISUAL:-vi}"
