#!/bin/bash

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Dotfiles 完整安装脚本${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检测操作系统
OS="$(uname)"
ARCH="$(uname -m)"
echo -e "${BLUE}检测到系统: ${YELLOW}${OS} ${ARCH}${NC}"
echo ""

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ============================================
# 步骤 1: 安装 Homebrew
# ============================================
echo -e "${YELLOW}📦 步骤 1/6: 检查并安装 Homebrew...${NC}"

if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Homebrew 未安装，开始安装...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # 配置 Homebrew 环境变量
    echo -e "${YELLOW}配置 Homebrew 环境变量...${NC}"

    if [[ "$OS" == "Darwin" ]]; then
        if [[ "$ARCH" == 'arm64' ]]; then
            # Apple Silicon
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            # Intel
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        # Linux
        HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
        echo "eval \"\$($HOMEBREW_PREFIX/bin/brew shellenv)\"" >> ~/.zprofile
        eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
    fi

    echo -e "${GREEN}✅ Homebrew 安装完成${NC}"
else
    echo -e "${GREEN}✅ Homebrew 已安装: $(brew --version)${NC}"
fi

echo ""

# ============================================
# 步骤 2: 安装 Chezmoi
# ============================================
echo -e "${YELLOW}🔧 步骤 2/6: 检查并安装 Chezmoi...${NC}"

if ! command -v chezmoi &> /dev/null; then
    echo -e "${YELLOW}Chezmoi 未安装，开始安装...${NC}"
    brew install chezmoi
    echo -e "${GREEN}✅ Chezmoi 安装完成${NC}"
else
    echo -e "${GREEN}✅ Chezmoi 已安装: $(chezmoi --version)${NC}"
fi

echo ""

# ============================================
# 步骤 3: 初始化 Dotfiles
# ============================================
echo -e "${YELLOW}📝 步骤 3/6: 初始化 Dotfiles...${NC}"

if [ -d ~/.local/share/chezmoi ]; then
    echo -e "${YELLOW}检测到已有 chezmoi 目录${NC}"
    read -p "$(echo -e ${YELLOW}是否重新初始化? [y/N]: ${NC})" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf ~/.local/share/chezmoi
        chezmoi init https://github.com/Phil-Fan/dot-files.git
        echo -e "${GREEN}✅ Dotfiles 重新初始化完成${NC}"
    else
        echo -e "${BLUE}跳过初始化，使用现有配置${NC}"
    fi
else
    chezmoi init https://github.com/Phil-Fan/dot-files.git
    echo -e "${GREEN}✅ Dotfiles 初始化完成${NC}"
fi

echo ""

# ============================================
# 步骤 4: 应用 Chezmoi 配置
# ============================================
echo -e "${YELLOW}⚙️  步骤 4/6: 应用配置文件...${NC}"
echo -e "${BLUE}将覆盖以下文件:${NC}"
echo -e "  - ~/.zshrc"
echo -e "  - ~/.gitconfig"
echo -e "  - ~/.zprofile"
echo -e "  - ~/.p10k.zsh"
echo -e "  - ~/.condarc"
echo ""
read -p "$(echo -e ${YELLOW}是否继续? [Y/n]: ${NC})" -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    chezmoi apply
    echo -e "${GREEN}✅ 配置文件应用完成${NC}"
else
    echo -e "${YELLOW}跳过配置应用${NC}"
fi

echo ""

# ============================================
# 步骤 5: 安装 Oh My Zsh 及插件
# ============================================
echo -e "${YELLOW}🔌 步骤 5/6: 安装 Oh My Zsh 及插件...${NC}"
echo -e "${BLUE}这将安装以下组件:${NC}"
echo -e "  - Oh My Zsh (框架)"
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

# ============================================
# 额外选项 1: 安装 Homebrew 软件包
# ============================================
echo -e "${YELLOW}🍺 额外选项 1: 安装 Homebrew 软件包?${NC}"
echo -e "${BLUE}这将安装 Brewfile 中定义的所有软件包${NC}"
read -p "$(echo -e ${YELLOW}是否安装? [y/N]: ${NC})" -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    bash "$SCRIPT_DIR/install-packages.sh"
fi

echo ""

# ============================================
# 额外选项 2: 安装全局 pnpm 包
# ============================================
echo -e "${YELLOW}📦 额���选项 2: 安装全局 pnpm 包?${NC}"
echo -e "${BLUE}这将安装 Pnpmfile 中定义的所有全局包${NC}"
echo -e "${BLUE}需要先安装 NVM 和 Node.js${NC}"
read -p "$(echo -e ${YELLOW}是否安装? [y/N]: ${NC})" -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # 检查 Node.js 和 pnpm 是否可用
    if command -v node &> /dev/null && command -v pnpm &> /dev/null; then
        echo -e "${GREEN}✅ Node.js 和 pnpm 已安装${NC}"
        bash "$SCRIPT_DIR/install-pnpm-global.sh"
    else
        echo -e "${RED}❌ 错误: Node.js 或 pnpm 未安装${NC}"
        echo -e "${YELLOW}请先安装 Homebrew 软件包（包含 NVM）${NC}"
    fi
fi

echo ""

# ============================================
# 完成
# ============================================
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   🎉 安装完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}下一步操作:${NC}"
echo -e "  ${GREEN}1.${NC} 重新加载 Shell: ${YELLOW}exec zsh${NC}"
echo -e "  ${GREEN}2.${NC} 或运行: ${YELLOW}source ~/.zshrc${NC}"
echo ""
