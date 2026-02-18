# 开发工具版本管理模块
# 文件: ~/.zsh_config/05-dev-tools.zsh

# ========== Node.js 版本管理 (NVM) ==========
export NVM_DIR="$HOME/.nvm"

# 优先使用 Homebrew 安装的 NVM，回退到手动安装路径
if [[ -n "$HOMEBREW_PREFIX" ]] && [[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]]; then
    source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
fi

if [[ -n "$HOMEBREW_PREFIX" ]] && [[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]]; then
    source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
fi

# Bun (JavaScript 运行时)
if [ -d "$HOME/.bun" ]; then
    export BUN_INSTALL="$HOME/.bun"
    path_prepend "$BUN_INSTALL/bin"
    [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
fi

# ========== Ruby 版本管理 (rbenv) ==========
if [ -d "$HOME/.rbenv" ]; then
    export RBENV_ROOT="$HOME/.rbenv"
    path_prepend "$RBENV_ROOT/bin"
    eval "$(rbenv init - zsh)"
fi

# ========== Java 版本管理 (jenv) ==========
if [ -d "$HOME/.jenv" ]; then
    export JENV_ROOT="$HOME/.jenv"
    path_prepend "$JENV_ROOT/bin"
    eval "$(jenv init -)"
fi

# ========== pnpm 包管理器 ==========
case "$(uname)" in
    Darwin)
        export PNPM_HOME="$HOME/Library/pnpm"
        ;;
    *)
        export PNPM_HOME="$HOME/.local/share/pnpm"
        ;;
esac

# 用户工具路径统一放后面，避免抢占语言管理器优先级
path_append "$PNPM_HOME"

# 统一收敛优先级：Homebrew 最前，语言管理器次之，用户工具最后
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    path_prepend "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"
fi
