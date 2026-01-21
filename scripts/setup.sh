#!/bin/bash
# chezmoi:executable

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Dotfiles 快速设置脚本${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检测操作系统
OS="$(uname)"
echo -e "${BLUE}检测到操作系统: ${YELLOW}${OS}${NC}"
echo ""

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. 应用 chezmoi 配置
echo -e "${YELLOW}📝 应用 chezmoi 配置...${NC}"
echo -e "${BLUE}这将会覆盖以下文件:${NC}"
echo -e "  - ~/.zshrc"
echo -e "  - ~/.gitconfig"
echo -e "  - ~/.zprofile"
echo -e "  - ~/.p10k.zsh"
echo -e "  - ~/.condarc"
echo ""
read -p "$(echo -e ${YELLOW}是否继续? [y/N]: ${NC})" -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    chezmoi apply
    echo -e "${GREEN}✅ chezmoi 配置应用完成${NC}"
else
    echo -e "${RED}❌ 已取消${NC}"
    exit 1
fi

echo ""

# 2. 安装 Oh My Zsh 自定义插件
echo -e "${YELLOW}🔌 安装 Oh My Zsh 自定义插件...${NC}"
echo -e "${BLUE}这将安装以下插件:${NC}"
echo -e "  - zsh-autosuggestions (命令自动建议)"
echo -e "  - zsh-syntax-highlighting (语法高亮)"
echo -e "  - powerlevel10k (主题)"
echo ""
read -p "$(echo -e ${YELLOW}是否安装? [Y/n]: ${NC})" -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    bash "$SCRIPT_DIR/install-oh-my-zsh-plugins.sh"
fi

echo ""

# 3. 根据操作系统安装软件
if [[ "$OS" == "Darwin" ]]; then
    echo -e "${YELLOW}🍺 安装 macOS 软件包...${NC}"
    read -p "$(echo -e ${YELLOW}是否安装 Homebrew 软件包? [y/N]: ${NC})" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        bash "$SCRIPT_DIR/install-packages.sh"
    fi
elif [[ "$OS" == "Linux" ]]; then
    echo -e "${YELLOW}🍺 安装 Linux 软件包（使用 Homebrew）...${NC}"
    read -p "$(echo -e ${YELLOW}是否安装 Homebrew 软件包? [y/N]: ${NC})" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        bash "$SCRIPT_DIR/install-packages.sh"
    fi
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   🎉 设置完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}接下来的步骤:${NC}"
echo -e "  1. ${YELLOW}重新加载 Shell:${NC} exec zsh"
echo -e "  2. ${YELLOW}或者:${NC} source ~/.zshrc"
echo ""
