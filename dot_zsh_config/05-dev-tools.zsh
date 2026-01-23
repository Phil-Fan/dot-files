# 开发工具版本管理模块
# 文件: ~/.zsh_config/05-dev-tools.zsh

# ========== Node.js 版本管理 (NVM) ==========
# NVM 配置和 pnpm 自动安装已在 ~/.zprofile 中处理

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
