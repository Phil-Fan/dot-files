# Oh My Zsh 配置模块
# 文件: ~/.zsh_config/02-oh-my-zsh.zsh

# Oh My Zsh 安装路径
export ZSH="$HOME/.oh-my-zsh"

# 自定义插件和主题目录
export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# 确保自���义插件目录存在
mkdir -p "$ZSH_CUSTOM/plugins"
mkdir -p "$ZSH_CUSTOM/themes"

# 主题设置
ZSH_THEME="powerlevel10k/powerlevel10k"

# 插件配置
plugins=(
    git
    zoxide
    fzf
    colored-man-pages
    command-not-found
    zsh-syntax-highlighting
    autojump
    zsh-autosuggestions
)

# 初始化 Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Powerlevel10k 配置
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
