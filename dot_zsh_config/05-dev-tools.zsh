# 开发工具版本管理模块
# 文件: ~/.zsh_config/05-dev-tools.zsh

# ========== Node.js 版本管理 (NVM) ==========
# NVM 通过 Homebrew 管理
export NVM_DIR="$HOME/.nvm"

# 优先使用 Homebrew 安装的 NVM
if [[ -s "$(brew --prefix nvm)/nvm.sh" ]]; then
    source "$(brew --prefix nvm)/nvm.sh"
# 兼容手动安装的 NVM
elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
fi

# ========== pnpm 包管理器 ==========
# 设置 PNPM_HOME（全局二进制文件存放路径）
case "$(uname)" in
    Darwin)
        # macOS
        export PNPM_HOME="$HOME/Library/pnpm"
        ;;
    *)
        # Linux
        export PNPM_HOME="$HOME/.local/share/pnpm"
        ;;
esac

# 添加 pnpm 全局二进制目录到 PATH
# pnpm 期望 PNPM_HOME 本身就是全局 bin 目录
export PATH="$PNPM_HOME:$PATH"

# Bun (JavaScript 运行时)
if [ -d "$HOME/.bun" ]; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
fi

# ========== Ruby 版本管理 (rbenv) ==========
if [ -d "$HOME/.rbenv" ]; then
    export PATH="$HOME/.rbenv/shims:$PATH"
    eval "$(rbenv init - zsh)"
fi

# ========== Java 版本管理 (jenv) ==========
if [ -d "$HOME/.jenv" ]; then
    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init -)"
fi
