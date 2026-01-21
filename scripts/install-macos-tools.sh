#!/bin/bash
# chezmoi:executable

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检测操作系统
if [[ "$(uname)" != "Darwin" ]]; then
    echo -e "${RED}❌ 此脚本仅在 macOS 上运行${NC}"
    exit 1
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   macOS 开发环境自动安装脚本${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BREWFILE_PATH="$SCRIPT_DIR/../packages/Brewfile"

# 1. 检查并安装 Homebrew
echo -e "${YELLOW}🍺 检查 Homebrew...${NC}"
if ! command -v brew &> /dev/null; then
    echo -e "${GREEN}📦 安装 Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # 根据架构设置 PATH
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    echo -e "${GREEN}✅ Homebrew 安装完成${NC}"
else
    echo -e "${GREEN}✅ Homebrew 已安装: $(brew --version | head -1)${NC}"
fi

echo ""

# 2. 更新 Homebrew
echo -e "${YELLOW}🔄 更新 Homebrew...${NC}"
brew update
echo -e "${GREEN}✅ Homebrew 更新完成${NC}"

echo ""

# 3. 从 Brewfile 安装软件包
echo -e "${YELLOW}📦 从 Brewfile 安装软件包...${NC}"

if [ -f "$BREWFILE_PATH" ]; then
    echo -e "${BLUE}正在安装软件包...${NC}"
    echo ""

    if brew bundle --file="$BREWFILE_PATH"; then
        echo -e "${GREEN}✅ 所有软件包安装完成${NC}"
    else
        echo -e "${RED}❌ 部分软件包安装失败${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Brewfile 未找到: $BREWFILE_PATH${NC}"
    exit 1
fi

echo ""

# 4. 清理旧版本
echo -e "${YELLOW}🧹 清理旧版本...${NC}"
brew cleanup
echo -e "${GREEN}✅ 清理完成${NC}"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   🎉 安装完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}建议:${NC}"
echo -e "  1. 重新加载 Shell: ${YELLOW}source ~/.zshrc${NC}"
echo -e "  2. 检查安装: ${YELLOW}brew doctor${NC}"
echo ""
