# 通用 Shell 配置头部
# 由 chezmoi 管理的模板文件

# 用户信息
export DEFAULT_USER="{{ .name }}"

# 通用 PATH
export PATH="$HOME/.local/bin:$PATH"

# 编辑器
export EDITOR="${EDITOR:-vi}"
export VISUAL="${VISUAL:-vi}"
