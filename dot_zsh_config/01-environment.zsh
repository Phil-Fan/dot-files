# 基础环境配置模块
# 文件: ~/.zsh_config/01-environment.zsh

# ============================================
# PATH 去重与排序工具
# ============================================
# path 数组会自动去重，保留最先出现的目录
typeset -gU path PATH

path_prepend() {
    local -a new_dirs
    local dir

    for dir in "$@"; do
        [[ -d "$dir" ]] && new_dirs+=("$dir")
    done

    (( ${#new_dirs[@]} )) && path=("${new_dirs[@]}" "${path[@]}")
}

path_append() {
    local dir

    for dir in "$@"; do
        [[ -d "$dir" ]] && path+=("$dir")
    done
}

# 用户信息
export DEFAULT_USER="$(whoami)"

# 用户工具路径放后面，避免覆盖语言管理器与系统工具
path_append "$HOME/.local/bin"

# 默认编辑器（后续会被 neovim 覆盖）
export EDITOR="${EDITOR:-vi}"
export VISUAL="${VISUAL:-vi}"

# llm CLI 配置目录统一放在 ~/.config/llm（由 dotfiles 管理非敏感配置）
export LLM_USER_PATH="${LLM_USER_PATH:-$HOME/.config/llm}"
