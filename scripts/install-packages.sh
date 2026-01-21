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
echo -e "${BLUE}   统一软件包安装脚本${NC}"
echo -e "${BLUE}   (macOS & Linux 使用 Homebrew)${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检测操作系统
OS="$(uname)"

echo -e "${BLUE}操作系统:${NC} ${YELLOW}$OS${NC}"
echo ""

# 包文件路径
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGES_DIR="$SCRIPT_DIR/../softwares/packages"

# macOS/Linux 通用安装函数
install_homebrew() {
    local brewfile="$1"

    echo -e "${YELLOW}🍺 检查 Homebrew...${NC}"

    if ! command -v brew &> /dev/null; then
        echo -e "${GREEN}📦 安装 Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # 配置 Homebrew 环境变量
        if [[ "$OS" == "Darwin" ]]; then
            if [[ $(uname -m) == 'arm64' ]]; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                eval "$(/opt/homebrew/bin/brew shellenv)"
            else
                echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        else
            # Linux Homebrew 安装路径
            if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
                echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zprofile
                eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            fi
        fi
    else
        echo -e "${GREEN}✅ Homebrew 已安装${NC}"
    fi

    echo ""
    echo -e "${YELLOW}📦 从 Brewfile 安装软件包...${NC}"
    echo -e "${BLUE}使用配置文件:${NC} $brewfile"
    brew bundle --file="$brewfile"

    echo ""
    echo -e "${GREEN}✅ 软件包安装完成${NC}"
}

# 根据操作系统选择对应的 Brewfile
case "$OS" in
    Darwin)
        install_homebrew "$PACKAGES_DIR/Brewfile"
        ;;
    Linux)
        install_homebrew "$PACKAGES_DIR/Brewfile-linux"
        ;;
    *)
        echo -e "${RED}❌ 不支持的操作系统: $OS${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   🎉 安装完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
