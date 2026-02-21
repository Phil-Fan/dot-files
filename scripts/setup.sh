#!/bin/bash

set -e

# ============================================
# 颜色定义
# ============================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ============================================
# 辅助函数
# ============================================
print_header() {
  echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC} ${BOLD}                    Dotfiles 安装向导                         ${NC}${CYAN}║${NC}"
  echo -e "${CYAN}╠════════════════════════════════════════════════════════════════╣${NC}"
  echo -e "${CYAN}║${NC} ${BOLD}一套完整的开发环境配置，涵盖 Shell、工具及语言环境            ${NC}${CYAN}║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
  echo ""
}

print_section() {
  local title="$1"
  local icon="$2"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "  ${BOLD}${CYAN}${icon} ${title}${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

print_step() {
  local step="$1"
  local total="$2"
  local title="$3"
  echo -e "${YELLOW}[${step}/${total}]${NC} ${BOLD}${title}${NC}"
}

print_success() {
  echo -e "  ${GREEN}✓${NC} ${1}"
}

print_info() {
  echo -e "  ${CYAN}▸${NC} ${1}"
}

print_warning() {
  echo -e "  ${YELLOW}⚠${NC} ${1}"
}

print_error() {
  echo -e "  ${RED}✗${NC} ${1}"
}

print_list() {
  echo -e "    ${BLUE}•${NC} ${1}"
}

confirm() {
  local prompt="$1"
  local default="${2:-Y}"
  if [[ "$default" == "Y" ]]; then
    read -p "$(echo -e "  ${YELLOW}▸${NC} ${prompt} [Y/n]: ")" -n 1 -r
    echo ""
    [[ ! $REPLY =~ ^[Nn]$ ]]
  else
    read -p "$(echo -e "  ${YELLOW}▸${NC} ${prompt} [y/N]: ")" -n 1 -r
    echo ""
    [[ $REPLY =~ ^[Yy]$ ]]
  fi
}

# ============================================
# 系统检测
# ============================================
print_header

OS="$(uname)"
ARCH="$(uname -m)"

case "$OS" in
  Darwin)
    OS_NAME="macOS"
    if [[ "$ARCH" == 'arm64' ]]; then
      OS_NAME="$OS_NAME (Apple Silicon)"
    else
      OS_NAME="$OS_NAME (Intel)"
    fi
    ;;
  Linux)
    OS_NAME="Linux"
    ;;
  *)
    OS_NAME="$OS"
    ;;
esac

print_info "检测到系统: ${BOLD}${OS_NAME}${NC}"
echo ""

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOTAL_STEPS=7

# ============================================
# 步骤 1: 安装 Homebrew
# ============================================
print_section "基础环境" "📦"
print_step "1" "$TOTAL_STEPS" "Homebrew 包管理器"
echo ""

if ! command -v brew &>/dev/null; then
  print_warning "Homebrew 未安装，正在安装..."

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  print_info "配置 Homebrew 环境变量（当前会话）..."

  # 仅在当前 shell 中加载，后续由 dotfiles 管理
  if [[ "$OS" == "Darwin" ]]; then
    if [[ "$ARCH" == 'arm64' ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi

  print_success "Homebrew 安装完成"
  print_info "环境变量将在 'chezmoi apply' 后永久生效"
else
  print_success "Homebrew 已安装: ${BOLD}$(brew --version | head -n1)${NC}"
fi

echo ""

# ============================================
# 步骤 2: 安装 Chezmoi
# ============================================
print_step "2" "$TOTAL_STEPS" "Chezmoi 配置管理"
echo ""

if ! command -v chezmoi &>/dev/null; then
  print_info "正在安装 Chezmoi..."
  brew install chezmoi
  print_success "Chezmoi 安装完成"
else
  print_success "Chezmoi 已安装: ${BOLD}$(chezmoi --version)${NC}"
fi

echo ""

# ============================================
# 步骤 3: 创建工作目录
# ============================================
print_section "工作目录" "📁"
print_step "3" "$TOTAL_STEPS" "创建开发工作区"
echo ""

echo "  将要创建的目录:"
print_list "$HOME/c - 课程与作业"
print_list "$HOME/l - 科研项目"
print_list "$HOME/i - 个人项目"
print_list "$HOME/f - 其他项目"
echo ""

DIRS=("$HOME/c" "$HOME/l" "$HOME/i" "$HOME/f")

for dir in "${DIRS[@]}"; do
  if [ ! -d "$dir" ]; then
    print_info "创建目录: $dir"
    mkdir -p "$dir"
  else
    print_success "目录已存在: $dir"
  fi
done

echo ""

# ============================================
# 步骤 4: 安装 Oh My Zsh
# ============================================
print_section "Shell 环境" "🐚"
print_step "4" "$TOTAL_STEPS" "Oh My Zsh 及插件"
echo ""

echo "  将要安装的组件:"
print_list "Oh My Zsh - Zsh 配置框架"
print_list "zsh-autosuggestions - 命令自动建议"
print_list "zsh-syntax-highlighting - 语法高亮"
print_list "powerlevel10k - 高性能主题"
echo ""

if confirm "是否安装 Oh My Zsh"; then
  bash "$SCRIPT_DIR/install-oh-my-zsh-plugins.sh"
else
  print_warning "已跳过 Oh My Zsh 安装"
fi

echo ""

# ============================================
# 步骤 5: 安装 Homebrew 软件包
# ============================================
print_section "开发工具" "🛠"
print_step "5" "$TOTAL_STEPS" "Homebrew 软件包"
echo ""

echo "  将要安装的内容:"
print_list "Brewfile 中的所有软件包"
print_list "包括 Git、Go、Neovim、fzf、ripgrep 等开发工具"
echo ""
print_warning "预计耗时: ~7 分钟 (取决于网络速度和软件包数量)"
echo ""

if confirm "是否安装软件包"; then
  bash "$SCRIPT_DIR/install-packages.sh"
else
  print_warning "已跳过软件包安装"
fi

echo ""

# ============================================
# 步骤 6: 配置 NVM 和 Node.js
# ============================================
print_section "Node.js 生态" ""
print_step "6" "$TOTAL_STEPS" "NVM + Node.js + pnpm"
echo ""

echo "  将要配置的内容:"
print_list "NVM - Node.js 版本管理器 (通过 Homebrew)"
print_list "Node.js - 最新 LTS 版本"
print_list "pnpm - 快速的包管理器"
print_list "全局 pnpm 包 (Pnpmfile)"
echo ""

if confirm "是否配置 Node.js 环境"; then
  # 设置 NVM 目录
  export NVM_DIR="$HOME/.nvm"

  # 加载 NVM
  # shellcheck disable=SC1091
  if [[ -s "$(brew --prefix nvm)/nvm.sh" ]]; then
    print_info "加载 NVM..."
    # shellcheck disable=SC1091
    source "$(brew --prefix nvm)/nvm.sh"
    print_success "NVM 已加载"
  elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
    print_info "加载 NVM..."
    # shellcheck disable=SC1091
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    print_success "NVM 已加载"
  else
    print_error "NVM 未找到"
    print_warning "请确保已在步骤 4 中安装 Homebrew 软件包"
    exit 1
  fi

  echo ""

  # 安装 Node.js
  if ! command -v node &>/dev/null; then
    print_info "安装 Node.js LTS..."
    nvm install --lts
    nvm use --lts
    nvm alias default lts/*
    print_success "Node.js 安装完成: ${BOLD}$(node -v)${NC}"
  else
    print_success "Node.js 已安装: ${BOLD}$(node -v)${NC}"
  fi

  echo ""

  # 安装 pnpm 和全局包
  bash "$SCRIPT_DIR/install-pnpm-global.sh"
else
  print_warning "已跳过 Node.js 配置"
fi

echo ""

# ============================================
# 步骤 7: 应用配置文件
# ============================================
print_section "配置应用" "⚙"
print_step "7" "$TOTAL_STEPS" "应用 Chezmoi 配置"
echo ""

echo "  将要覆盖的文件:"
print_list "$HOME/.zshrc - Zsh 配置"
print_list "$HOME/.gitconfig - Git 配置"
print_list "$HOME/.zprofile - Shell 环境配置"
print_list "$HOME/.p10k.zsh - Powerlevel10k 主题配置"
print_list "$HOME/.condarc - Conda 配置"
echo ""

if confirm "是否应用配置文件"; then
  chezmoi apply
  print_success "配置文件应用完成"
else
  print_warning "已跳过配置应用"
fi

echo ""

# ============================================
# 安装完成
# ============================================
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC} ${BOLD}                        安装完成！                              ${NC}${GREEN}║${NC}"
echo -e "${GREEN}╠════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}║${NC} ${BOLD}🎉 所有组件已成功安装                                        ${NC}${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BOLD}${CYAN}下一步操作:${NC}"
echo ""
print_list "${GREEN}重新加载 Shell${NC} → 运行: ${BOLD}exec zsh${NC}"
print_list "${GREEN}或重新加载配置${NC} → 运行: ${BOLD}source ~/.zshrc${NC}"
echo ""
