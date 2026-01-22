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

# ============ Yazi 终端文件管理器 ============
# Yazi shell wrapper - 支持 CD 切换功能
# 使用: y [目录]  启动 yazi，退出时按 q 切换到当前目录，按 Q 不切换
if command -v yazi >/dev/null 2>&1; then
    function y() {
        local tmp
        tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd" || return
        fi
        rm -f -- "$tmp"
    }
fi
