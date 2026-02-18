# 平台特定配置模块
# 文件: ~/.zsh_config/06-platform.zsh

# ========== macOS 配置 ==========
if [[ "$OSTYPE" == darwin* ]]; then
    # X11 设置
    export DISPLAY="${DISPLAY:-:0}"

    # Docker CLI completions
    [[ -d "$HOME/.docker/completions" ]] && fpath=($HOME/.docker/completions $fpath)

    # iTerm2 Shell Integration
    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fi

# ========== Linux 配置 ==========
if [[ "$OSTYPE" == linux* ]]; then
    # 在这里添加 Linux 特定配置
    :
fi
