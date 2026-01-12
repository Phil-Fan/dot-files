# 基础环境配置模块
# 文件: ~/.zsh_config/01-environment.zsh

# 用户信息
export DEFAULT_USER="$(whoami)"

# 通用 PATH
export PATH="$HOME/.local/bin:$PATH"

# 默认编辑器（后续会被 neovim 覆盖）
export EDITOR="${EDITOR:-vi}"
export VISUAL="${VISUAL:-vi}"
