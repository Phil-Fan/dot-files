#!/bin/bash
# chezmoi:template
# chezmoi:executable

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Oh My Zsh 及插件安装脚本${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 0. 检查并安装 Oh My Zsh
ZSH="$HOME/.oh-my-zsh"
# 检查核心文件是否存在（而不是只检查目录）
if [ ! -f "$ZSH/oh-my-zsh.sh" ]; then
    echo -e "${YELLOW}[0/4]${NC} 安装 Oh My Zsh..."
    echo -e "${BLUE}正在下载并安装 Oh My Zsh...${NC}"

    # 如果目录存在但不完整，先清理
    if [ -d "$ZSH" ]; then
        echo -e "${YELLOW}检测到不完整的安装，正在清理...${NC}"
        rm -rf "$ZSH"
    fi

    # 方法1: 使用官方安装脚本
    if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
        # 验证安装
        if [ -f "$ZSH/oh-my-zsh.sh" ]; then
            echo -e "${GREEN}✅ Oh My Zsh 安装成功${NC}"
        else
            echo -e "${RED}❌ 安装脚本执行成功但文件缺失，尝试备用方法...${NC}"
            rm -rf "$ZSH"

            # 方法2: 直接 clone 仓库
            echo -e "${YELLOW}使用 Git 直接克隆...${NC}"
            if command -v git &> /dev/null; then
                git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"
                if [ -f "$ZSH/oh-my-zsh.sh" ]; then
                    echo -e "${GREEN}✅ Oh My Zsh 安装成功（Git 方式）${NC}"
                else
                    echo -e "${RED}❌ Git 克隆后仍缺少核心文件${NC}"
                    exit 1
                fi
            else
                echo -e "${RED}❌ Git 未安装，无法使用备用方法${NC}"
                exit 1
            fi
        fi
    else
        echo -e "${RED}❌ Oh My Zsh 安装失败${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ Oh My Zsh 已安装，跳过${NC}"
fi

echo ""

# Oh My Zsh 自定义目录
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"
PLUGINS_DIR="$ZSH_CUSTOM/plugins"
THEMES_DIR="$ZSH_CUSTOM/themes"

# 确保目录存在
echo -e "${YELLOW}📁 创建自定义插件目录...${NC}"
mkdir -p "$PLUGINS_DIR"
mkdir -p "$THEMES_DIR"
echo -e "${GREEN}✅ 目录创建完成${NC}"

echo ""

# 函数：安装 Git 仓库
install_repo() {
    local name=$1
    local url=$2
    local target=$3
    
    if [ -d "$target" ]; then
        echo -e "${YELLOW}⚠️  $name 已存在，跳过安装${NC}"
        return 0
    fi
    
    echo -e "${BLUE}📦 安装 $name...${NC}"
    if git clone --depth=1 "$url" "$target" 2>/dev/null; then
        echo -e "${GREEN}✅ $name 安装成功${NC}"
        return 0
    else
        echo -e "${RED}❌ $name 安装失败${NC}"
        return 1
    fi
}

# 1. zsh-autosuggestions
echo -e "${YELLOW}[1/3]${NC} 安装 zsh-autosuggestions..."
install_repo "zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-autosuggestions" \
    "$PLUGINS_DIR/zsh-autosuggestions"

echo ""

# 2. zsh-syntax-highlighting
echo -e "${YELLOW}[2/3]${NC} 安装 zsh-syntax-highlighting..."
install_repo "zsh-syntax-highlighting" \
    "https://github.com/zsh-users/zsh-syntax-highlighting" \
    "$PLUGINS_DIR/zsh-syntax-highlighting"

echo ""

# 3. powerlevel10k
echo -e "${YELLOW}[3/3]${NC} 安装 Powerlevel10k..."
install_repo "Powerlevel10k" \
    "https://github.com/romkatv/powerlevel10k.git" \
    "$THEMES_DIR/powerlevel10k"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   🎉 安装完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}已安装组件:${NC}"
echo -e "  ✅ Oh My Zsh"
echo -e "  ✅ zsh-autosuggestions"
echo -e "  ✅ zsh-syntax-highlighting"
echo -e "  ✅ powerlevel10k"
echo ""
echo -e "${BLUE}接下来的步骤:${NC}"
echo -e "  1. ${YELLOW}重新加载 Shell:${NC} exec zsh"
echo -e "  2. ${YELLOW}或运行:${NC} source ~/.zshrc"
echo ""
