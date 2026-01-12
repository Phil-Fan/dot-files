# 平台特定配置模块
# 文件: ~/.zsh_config/06-platform.zsh

# ========== macOS 配置 ==========
if [[ "$OSTYPE" == darwin* ]]; then
    # X11 设置
    export DISPLAY="${DISPLAY:-:0}"

    # Homebrew - 自动检测架构
    if [[ -d "/opt/homebrew" ]]; then
        # Apple Silicon
        export PATH="/opt/homebrew/bin:$PATH"
        export HOMEBREW_PREFIX="/opt/homebrew"
    elif [[ -d "/usr/local" ]]; then
        # Intel
        export PATH="/usr/local/bin:$PATH"
        export HOMEBREW_PREFIX="/usr/local"
    fi

    # Docker CLI completions
    fpath=($HOME/.docker/completions $fpath)
    autoload -Uz compinit
    compinit

    # iTerm2 Shell Integration
    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fi

# ========== Linux 配置 ==========
if [[ "$OSTYPE" == linux* ]]; then
    # 在这里添加 Linux 特定配置
    :
fi
